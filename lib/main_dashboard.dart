import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/auth_provider.dart';
import 'models/user_model.dart';
import 'features/auth/auth_screen.dart';
import 'features/matching/matching_page.dart';
import 'features/chat/chat_page.dart';
import 'features/documents/documents_page.dart';
import 'features/profile/profile_page.dart';
import 'features/matching/seeker_request_help_page.dart';
import 'features/matching/navigator_help_requests_page.dart';
import 'features/trips/my_trips_page.dart';
import 'features/documents/walkthrough_list_page.dart';
import 'features/airport/airport_guides_page.dart';
import 'features/profile/badges_stats_page.dart';
import 'features/trips/track_flight_page.dart';
import 'features/admin/admin_page.dart';

class MainDashboard extends ConsumerStatefulWidget {
  const MainDashboard({super.key});

  @override
  ConsumerState<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends ConsumerState<MainDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final currentUser = ref.watch(currentUserProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          // User is not authenticated, show auth screen
          return const AuthScreen();
        }

                  return currentUser.when(
            data: (userModel) {
              if (userModel == null) {
                // User authenticated but no profile data, show error with retry
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.orange),
                        const SizedBox(height: 16),
                        const Text(
                          'User profile not found',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Please try logging in again or contact support.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await ref.read(authProvider.notifier).signOut();
                                if (context.mounted) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                                  );
                                }
                              },
                              child: const Text('Sign Out'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // Try to create user profile manually
                                final authState = ref.read(authProvider);
                                if (authState.value != null) {
                                  final user = authState.value!;
                                  final newUser = UserModel(
                                    id: user.id,
                                    email: user.email,
                                    name: user.name,
                                    role: 'seeker',
                                    createdAt: DateTime.now(),
                                    lastActive: DateTime.now(),
                                  );
                                  try {
                                    await ref.read(firestoreServiceProvider).createUser(newUser);
                                    // Store context before async operation
                                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                                    scaffoldMessenger.showSnackBar(
                                      const SnackBar(content: Text('Profile created! Refreshing...')),
                                    );
                                    // Force refresh
                                    ref.invalidate(currentUserProvider);
                                  } catch (e) {
                                    // Store context before async operation
                                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                                    scaffoldMessenger.showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                }
                              },
                              child: const Text('Create Profile'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }

            return Scaffold(
              body: _pages(userModel.role)[_selectedIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (index) => setState(() => _selectedIndex = index),
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Matching'),
                  BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
                  BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Documents'),
                  BottomNavigationBarItem(icon: Icon(Icons.flight), label: 'Track Flight'),
                  BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
                ],
              ),
            );
          },
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error loading user data: $error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.read(authProvider.notifier).signOut(),
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Authentication error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                ),
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _pages(String userRole) {
    return [
      HomePage(userRole: userRole),
      const MatchingPage(),
      const ChatPage(),
      const DocumentsPage(),
      const TrackFlightTabPage(),
      const ProfilePage(),
    ];
  }
}

class HomePage extends ConsumerWidget {
  final String userRole;
  
  const HomePage({super.key, required this.userRole});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Airway Ally Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Show confirmation dialog
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sign Out'),
                  content: const Text('Are you sure you want to sign out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
              );
              
              if (shouldLogout == true) {
                await ref.read(authProvider.notifier).signOut();
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: userRole == 'seeker' ? _seekerHome(context) : _navigatorHome(context),
      ),
    );
  }

  Widget _seekerHome(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Welcome, Seeker!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('Find a Navigator for your next journey.'),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          icon: const Icon(Icons.search),
          label: const Text('Request Help'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SeekerRequestHelpPage()),
            );
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.flight),
          label: const Text('My Trips'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MyTripsPage()),
            );
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.description),
          label: const Text('Document Assistance'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const WalkthroughListPage()),
            );
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.map),
          label: const Text('Airport Guides'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AirportGuidesPage()),
            );
          },
        ),
        const SizedBox(height: 32),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Tips for First-Time Travelers', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('• Arrive early for your flight.'),
                Text('• Keep your documents handy.'),
                Text('• Don’t hesitate to ask for help!'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _navigatorHome(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Welcome, Navigator!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('Help a Seeker and earn badges.'),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          icon: const Icon(Icons.people),
          label: const Text('View Help Requests'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const NavigatorHelpRequestsPage()),
            );
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.flight),
          label: const Text('My Trips'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MyTripsPage()),
            );
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.emoji_events),
          label: const Text('My Badges & Stats'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const BadgesStatsPage()),
            );
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.description),
          label: const Text('Document Assistance'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const WalkthroughListPage()),
            );
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.admin_panel_settings),
          label: const Text('Admin Panel'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AdminPage()),
            );
          },
        ),
        const SizedBox(height: 32),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Navigator Tips', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('• Be patient and clear in your guidance.'),
                Text('• Share your travel experience.'),
                Text('• Encourage and reassure Seekers.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TrackFlightTabPage extends StatefulWidget {
  const TrackFlightTabPage({super.key});

  @override
  State<TrackFlightTabPage> createState() => _TrackFlightTabPageState();
}

class _TrackFlightTabPageState extends State<TrackFlightTabPage> {
  final _formKey = GlobalKey<FormState>();
  final _flightController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  DateTime? _selectedDate;
  bool _showResult = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Track Flight')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _showResult
            ? TrackFlightPage(
                flightNumber: _flightController.text,
                from: _fromController.text,
                to: _toController.text,
                date: _selectedDate != null
                    ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
                    : '',
              )
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Enter Flight Info', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _flightController,
                      decoration: const InputDecoration(
                        labelText: 'Flight Number',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.flight),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Enter flight number' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _fromController,
                            decoration: const InputDecoration(
                              labelText: 'Departure Airport',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.flight_takeoff),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _toController,
                            decoration: const InputDecoration(
                              labelText: 'Arrival Airport',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.flight_land),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Date of Travel'),
                      subtitle: Text(_selectedDate == null
                          ? 'Select date'
                          : '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) setState(() => _selectedDate = picked);
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _showResult = true);
                        }
                      },
                      child: const Text('Track Flight'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _flightController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }
} 