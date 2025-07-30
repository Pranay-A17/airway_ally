import 'package:flutter/material.dart';

class AirportGuidesPage extends StatelessWidget {
  const AirportGuidesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final airports = [
      {
        'code': 'JFK',
        'name': 'John F. Kennedy International Airport',
        'location': 'New York, USA',
        'terminals': 6,
        'description': 'One of the busiest airports in the world, serving over 60 million passengers annually.',
        'image': 'JFK',
      },
      {
        'code': 'LHR',
        'name': 'London Heathrow Airport',
        'location': 'London, UK',
        'terminals': 5,
        'description': 'The UK\'s largest and busiest airport, with flights to over 200 destinations.',
        'image': 'LHR',
      },
      {
        'code': 'DXB',
        'name': 'Dubai International Airport',
        'location': 'Dubai, UAE',
        'terminals': 3,
        'description': 'The world\'s busiest airport for international passenger traffic.',
        'image': 'DXB',
      },
      {
        'code': 'NRT',
        'name': 'Narita International Airport',
        'location': 'Tokyo, Japan',
        'terminals': 3,
        'description': 'Tokyo\'s main international airport, serving over 40 million passengers annually.',
        'image': 'NRT',
      },
      {
        'code': 'CDG',
        'name': 'Charles de Gaulle Airport',
        'location': 'Paris, France',
        'terminals': 3,
        'description': 'France\'s largest international airport and Europe\'s second busiest.',
        'image': 'CDG',
      },
      {
        'code': 'SIN',
        'name': 'Singapore Changi Airport',
        'location': 'Singapore',
        'terminals': 4,
        'description': 'Consistently ranked as the world\'s best airport with amazing amenities.',
        'image': 'SIN',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Airport Guides'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search coming soon!')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Major Airports',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Find detailed guides for major airports worldwide',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),
            ...airports.map((airport) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AirportDetailPage(airport: airport),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                airport['code'] as String,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  airport['name'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  airport['location'] as String,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${airport['terminals']} Terminals',
                                  style: TextStyle(
                                    color: Colors.blue[600],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class AirportDetailPage extends StatelessWidget {
  final Map<String, dynamic> airport;

  const AirportDetailPage({super.key, required this.airport});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${airport['code']} Guide'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share coming soon!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade600],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    airport['code'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    airport['name'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    airport['location'] as String,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Description
            const Text(
              'About',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              airport['description'] as String,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),

            // Quick Info
            const Text(
              'Quick Info',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoCard([
              {'icon': Icons.terminal, 'title': 'Terminals', 'value': '${airport['terminals']}'},
              {'icon': Icons.access_time, 'title': 'Check-in', 'value': '3 hours before'},
              {'icon': Icons.security, 'title': 'Security', 'value': 'Allow extra time'},
              {'icon': Icons.wifi, 'title': 'WiFi', 'value': 'Free available'},
            ]),
            const SizedBox(height: 24),

            // Terminals
            const Text(
              'Terminals',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildTerminalsList(context),
            const SizedBox(height: 24),

            // Amenities
            const Text(
              'Amenities',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildAmenitiesGrid(),
            const SizedBox(height: 24),

            // Transportation
            const Text(
              'Transportation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildTransportationList(),
            const SizedBox(height: 24),

            // Tips
            const Text(
              'Travel Tips',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildTipsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Map<String, dynamic>> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(item['icon'] as IconData, color: Colors.blue, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text(item['title'] as String)),
                Text(
                  item['value'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildTerminalsList(BuildContext context) {
    final terminals = List.generate(
      airport['terminals'] as int,
      (index) => {
        'name': 'Terminal ${String.fromCharCode(65 + index)}',
        'description': 'International and domestic flights',
        'gates': '${10 + (index * 5)} gates',
      },
    );

    return Column(
      children: terminals.map((terminal) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Text(
              terminal['name']!.split(' ')[1],
              style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(terminal['name'] as String),
          subtitle: Text(terminal['description'] as String),
          trailing: Text(
            terminal['gates'] as String,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          onTap: () {
            // TODO: Navigate to terminal detail
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${terminal['name']} details coming soon!')),
            );
          },
        ),
      )).toList(),
    );
  }

  Widget _buildAmenitiesGrid() {
    final amenities = [
      {'icon': Icons.restaurant, 'name': 'Restaurants', 'count': '50+'},
      {'icon': Icons.shopping_bag, 'name': 'Shops', 'count': '100+'},
      {'icon': Icons.local_hotel, 'name': 'Hotels', 'count': '3'},
      {'icon': Icons.local_parking, 'name': 'Parking', 'count': 'Available'},
      {'icon': Icons.medical_services, 'name': 'Medical', 'count': '24/7'},
      {'icon': Icons.currency_exchange, 'name': 'Currency', 'count': 'Available'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: amenities.length,
      itemBuilder: (context, index) {
        final amenity = amenities[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(amenity['icon'] as IconData, color: Colors.blue, size: 24),
                const SizedBox(height: 4),
                Text(
                  amenity['name'] as String,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  amenity['count'] as String,
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransportationList() {
    final transport = [
      {'type': 'Train', 'time': '15-30 min', 'cost': '\$5-15', 'icon': Icons.train},
      {'type': 'Bus', 'time': '30-45 min', 'cost': '\$2-8', 'icon': Icons.directions_bus},
      {'type': 'Taxi', 'time': '20-40 min', 'cost': '\$30-80', 'icon': Icons.local_taxi},
      {'type': 'Ride Share', 'time': '20-40 min', 'cost': '\$25-70', 'icon': Icons.car_rental},
    ];

    return Column(
      children: transport.map((item) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: Icon(item['icon'] as IconData, color: Colors.blue),
          title: Text(item['type'] as String),
          subtitle: Text('${item['time']} to city center'),
          trailing: Text(
            item['cost'] as String,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildTipsList() {
    final tips = [
      'Arrive at least 3 hours before international flights',
      'Keep your boarding pass and ID easily accessible',
      'Pack liquids in clear, resealable bags',
      'Download the airport app for real-time updates',
      'Consider TSA PreCheck for faster security screening',
      'Have backup copies of important documents',
    ];

    return Column(
      children: tips.asMap().entries.map((entry) {
        final index = entry.key;
        final tip = entry.value;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(
                '${index + 1}',
                style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(tip),
          ),
        );
      }).toList(),
    );
  }
} 