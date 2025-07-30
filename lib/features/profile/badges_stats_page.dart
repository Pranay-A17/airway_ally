import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BadgesStatsPage extends ConsumerStatefulWidget {
  const BadgesStatsPage({super.key});

  @override
  ConsumerState<BadgesStatsPage> createState() => _BadgesStatsPageState();
}

class _BadgesStatsPageState extends ConsumerState<BadgesStatsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Badges & Stats'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Badges'),
            Tab(text: 'Stats'),
            Tab(text: 'Achievements'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBadgesTab(),
          _buildStatsTab(),
          _buildAchievementsTab(),
        ],
      ),
    );
  }

  Widget _buildBadgesTab() {
    final badges = [
      {
        'name': 'First Flight',
        'description': 'Complete your first navigation session',
        'icon': Icons.flight_takeoff,
        'color': Colors.blue,
        'isUnlocked': true,
        'unlockedDate': DateTime.now().subtract(const Duration(days: 30)),
        'rarity': 'Common',
      },
      {
        'name': 'Helpful Navigator',
        'description': 'Help 10 different seekers',
        'icon': Icons.people,
        'color': Colors.green,
        'isUnlocked': true,
        'unlockedDate': DateTime.now().subtract(const Duration(days: 15)),
        'rarity': 'Rare',
      },
      {
        'name': 'Document Expert',
        'description': 'Upload and organize 20 documents',
        'icon': Icons.description,
        'color': Colors.orange,
        'isUnlocked': false,
        'progress': 15,
        'total': 20,
        'rarity': 'Epic',
      },
      {
        'name': 'Chat Master',
        'description': 'Send 100 messages in chat',
        'icon': Icons.chat,
        'color': Colors.purple,
        'isUnlocked': false,
        'progress': 67,
        'total': 100,
        'rarity': 'Legendary',
      },
      {
        'name': 'Airport Explorer',
        'description': 'Visit 5 different airports',
        'icon': Icons.local_airport,
        'color': Colors.teal,
        'isUnlocked': false,
        'progress': 3,
        'total': 5,
        'rarity': 'Rare',
      },
      {
        'name': 'Perfect Rating',
        'description': 'Maintain 5-star rating for 30 days',
        'icon': Icons.star,
        'color': Colors.amber,
        'isUnlocked': false,
        'progress': 12,
        'total': 30,
        'rarity': 'Legendary',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressSummary(badges),
          const SizedBox(height: 24),
          const Text(
            'Your Badges',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: badges.length,
            itemBuilder: (context, index) {
              final badge = badges[index];
              return _buildBadgeCard(badge);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSummary(List<Map<String, dynamic>> badges) {
    final unlockedCount = badges.where((b) => b['isUnlocked']).length;
    final totalCount = badges.length;
    final progress = (unlockedCount / totalCount) * 100;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$unlockedCount/$totalCount',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${progress.round()}%',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 8),
            Text(
              'Badges Unlocked',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeCard(Map<String, dynamic> badge) {
    final isUnlocked = badge['isUnlocked'] as bool;
    final progress = badge['progress'] as int?;
    final total = badge['total'] as int?;

    return Card(
      child: InkWell(
        onTap: () => _showBadgeDetails(badge),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isUnlocked ? badge['color'] : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  badge['icon'] as IconData,
                  color: isUnlocked ? Colors.white : Colors.grey[500],
                  size: 30,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                badge['name'] as String,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isUnlocked ? Colors.black : Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              if (!isUnlocked && progress != null && total != null) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress / total,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(badge['color'] as Color),
                ),
                const SizedBox(height: 4),
                Text(
                  '$progress/$total',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getRarityColor(badge['rarity'] as String).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge['rarity'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    color: _getRarityColor(badge['rarity'] as String),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRarityColor(String rarity) {
    switch (rarity) {
      case 'Common':
        return Colors.grey;
      case 'Rare':
        return Colors.blue;
      case 'Epic':
        return Colors.purple;
      case 'Legendary':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  void _showBadgeDetails(Map<String, dynamic> badge) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(badge['icon'] as IconData, color: badge['color'] as Color),
            const SizedBox(width: 8),
            Expanded(child: Text(badge['name'] as String)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(badge['description'] as String),
            const SizedBox(height: 16),
            if (badge['isUnlocked'] && badge['unlockedDate'] != null) ...[
              Text(
                'Unlocked: ${_formatDate(badge['unlockedDate'] as DateTime)}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getRarityColor(badge['rarity'] as String).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge['rarity'] as String,
                style: TextStyle(
                  color: _getRarityColor(badge['rarity'] as String),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsTab() {
    final stats = [
      {'title': 'Total Sessions', 'value': '47', 'icon': Icons.flight, 'color': Colors.blue},
      {'title': 'Seekers Helped', 'value': '23', 'icon': Icons.people, 'color': Colors.green},
      {'title': 'Documents Uploaded', 'value': '15', 'icon': Icons.description, 'color': Colors.orange},
      {'title': 'Messages Sent', 'value': '67', 'icon': Icons.chat, 'color': Colors.purple},
      {'title': 'Airports Visited', 'value': '3', 'icon': Icons.local_airport, 'color': Colors.teal},
      {'title': 'Average Rating', 'value': '4.8', 'icon': Icons.star, 'color': Colors.amber},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Statistics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              final stat = stats[index];
              return _buildStatCard(stat);
            },
          ),
          const SizedBox(height: 24),
          _buildActivityChart(),
        ],
      ),
    );
  }

  Widget _buildStatCard(Map<String, dynamic> stat) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              stat['icon'] as IconData,
              color: stat['color'] as Color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              stat['value'] as String,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              stat['title'] as String,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildBar('Mon', 3, Colors.blue),
                  _buildBar('Tue', 5, Colors.blue),
                  _buildBar('Wed', 2, Colors.blue),
                  _buildBar('Thu', 7, Colors.blue),
                  _buildBar('Fri', 4, Colors.blue),
                  _buildBar('Sat', 6, Colors.blue),
                  _buildBar('Sun', 3, Colors.blue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(String label, int value, Color color) {
    final maxHeight = 150.0;
    final height = (value / 7) * maxHeight;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        Text(
          '$value',
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildAchievementsTab() {
    final achievements = [
      {
        'title': 'First Steps',
        'description': 'Complete your first navigation session',
        'icon': Icons.directions_walk,
        'isCompleted': true,
        'completedDate': DateTime.now().subtract(const Duration(days: 45)),
      },
      {
        'title': 'Helpful Hand',
        'description': 'Help your first seeker',
        'icon': Icons.volunteer_activism,
        'isCompleted': true,
        'completedDate': DateTime.now().subtract(const Duration(days: 40)),
      },
      {
        'title': 'Document Master',
        'description': 'Upload your first document',
        'icon': Icons.upload_file,
        'isCompleted': true,
        'completedDate': DateTime.now().subtract(const Duration(days: 35)),
      },
      {
        'title': 'Chat Enthusiast',
        'description': 'Send your first message',
        'icon': Icons.message,
        'isCompleted': true,
        'completedDate': DateTime.now().subtract(const Duration(days: 30)),
      },
      {
        'title': 'Airport Explorer',
        'description': 'Visit your first airport',
        'icon': Icons.explore,
        'isCompleted': true,
        'completedDate': DateTime.now().subtract(const Duration(days: 25)),
      },
      {
        'title': 'Perfect Rating',
        'description': 'Receive your first 5-star rating',
        'icon': Icons.star,
        'isCompleted': false,
      },
      {
        'title': 'Week Warrior',
        'description': 'Complete 7 sessions in a week',
        'icon': Icons.calendar_today,
        'isCompleted': false,
      },
      {
        'title': 'Social Butterfly',
        'description': 'Help 10 different seekers',
        'icon': Icons.groups,
        'isCompleted': false,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return _buildAchievementCard(achievement);
      },
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    final isCompleted = achievement['isCompleted'] as bool;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isCompleted ? Colors.green : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            achievement['icon'] as IconData,
            color: isCompleted ? Colors.white : Colors.grey[500],
          ),
        ),
        title: Text(
          achievement['title'] as String,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isCompleted ? Colors.black : Colors.grey[600],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(achievement['description'] as String),
            if (isCompleted && achievement['completedDate'] != null)
              Text(
                'Completed: ${_formatDate(achievement['completedDate'] as DateTime)}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
          ],
        ),
        trailing: Icon(
          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isCompleted ? Colors.green : Colors.grey,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
} 