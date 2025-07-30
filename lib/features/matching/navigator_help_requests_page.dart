import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/data_providers.dart';
import '../../providers/auth_provider.dart';
import '../../models/help_request_model.dart';

class NavigatorHelpRequestsPage extends ConsumerStatefulWidget {
  const NavigatorHelpRequestsPage({super.key});

  @override
  ConsumerState<NavigatorHelpRequestsPage> createState() => _NavigatorHelpRequestsPageState();
}

class _NavigatorHelpRequestsPageState extends ConsumerState<NavigatorHelpRequestsPage> {
  void _acceptRequest(HelpRequestModel request) async {
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser != null) {
      await ref.read(helpRequestProvider.notifier).acceptHelpRequest(
        request.id,
        currentUser.id,
        currentUser.name,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Help request accepted! You can now chat with ${request.seekerName}.')),
        );
      }
    }
  }

  void _declineRequest(HelpRequestModel request) async {
    // For now, we'll just show a message since we don't have a decline endpoint
    // In a real app, you might want to track declined requests
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Help request declined.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final helpRequestsAsync = ref.watch(helpRequestsForNavigatorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Requests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filtering
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filter options coming soon!')),
              );
            },
          ),
        ],
      ),
      body: helpRequestsAsync.when(
        data: (helpRequests) => helpRequests.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No pending help requests',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Check back later for new requests',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: helpRequests.length,
                itemBuilder: (context, index) {
                  final request = helpRequests[index];
                  final isAccepted = request.status == 'accepted';
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.blue.shade100,
                                child: Text(
                                  request.seekerName.substring(0, 1),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      request.seekerName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.star, size: 16, color: Colors.amber.shade600),
                                        const SizedBox(width: 4),
                                        Text('${request.seekerRating}'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (isAccepted)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Accepted',
                                    style: TextStyle(
                                      color: Colors.green.shade700,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Icon(Icons.flight, size: 16, color: Colors.grey.shade600),
                              const SizedBox(width: 8),
                              Text(
                                request.airport,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                              const SizedBox(width: 8),
                              Text('${_formatDate(request.date)} at ${request.time}'),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            request.description,
                            style: const TextStyle(fontSize: 14),
                          ),
                          if (!isAccepted) ...[
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => _declineRequest(request),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      side: const BorderSide(color: Colors.red),
                                    ),
                                    child: const Text('Decline'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _acceptRequest(request),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Accept'),
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Navigate to chat with this seeker
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Chat feature coming soon!')),
                                );
                              },
                              icon: const Icon(Icons.chat),
                              label: const Text('Start Chat'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading help requests',
                style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
} 