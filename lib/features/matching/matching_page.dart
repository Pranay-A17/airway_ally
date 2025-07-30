import 'package:flutter/material.dart';

enum UserRole { seeker, navigator }

class MatchingPage extends StatefulWidget {
  const MatchingPage({super.key});

  @override
  State<MatchingPage> createState() => _MatchingPageState();
}

class _MatchingPageState extends State<MatchingPage> {
  UserRole _role = UserRole.seeker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matching'),
        actions: [
          DropdownButton<UserRole>(
            value: _role,
            underline: const SizedBox(),
            icon: const Icon(Icons.swap_horiz, color: Colors.white),
            dropdownColor: Colors.white,
            items: const [
              DropdownMenuItem(value: UserRole.seeker, child: Text('Seeker')),
              DropdownMenuItem(value: UserRole.navigator, child: Text('Navigator')),
            ],
            onChanged: (role) {
              if (role != null) setState(() => _role = role);
            },
          ),
        ],
      ),
      body: _role == UserRole.seeker ? _seekerView() : _navigatorView(),
    );
  }

  Widget _seekerView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.search, size: 48, color: Colors.blue),
          SizedBox(height: 16),
          Text('Your help request is being matched with a Navigator...', textAlign: TextAlign.center),
          SizedBox(height: 24),
          Text('Status: Searching for Navigator', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _navigatorView() {
    final requests = [
      {'flight': 'AA123', 'from': 'JFK', 'to': 'LHR', 'date': '2024-07-10', 'seeker': 'Alice'},
      {'flight': 'BA456', 'from': 'LHR', 'to': 'CDG', 'date': '2024-08-01', 'seeker': 'Bob'},
    ];
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text('Help Requests', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        ...requests.map((req) => Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text('${req['seeker']} - ${req['flight']}'),
                subtitle: Text('${req['from']} → ${req['to']}\nDate: ${req['date']}'),
                trailing: ElevatedButton(
                  onPressed: () {
                    // TODO: Accept request
                  },
                  child: const Text('Accept'),
                ),
              ),
            )),
      ],
    );
  }
} 