import 'package:flutter/material.dart';

class WalkthroughListPage extends StatelessWidget {
  final String? selectedDocument;
  
  const WalkthroughListPage({super.key, this.selectedDocument});

  @override
  Widget build(BuildContext context) {
    final allWalkthroughs = {
      'Passport Application': [
        {'title': 'New Passport Application', 'desc': 'Complete guide for first-time passport applications.', 'steps': 8},
        {'title': 'Passport Renewal', 'desc': 'How to renew your existing passport.', 'steps': 6},
        {'title': 'Passport Photo Requirements', 'desc': 'Photo specifications and requirements.', 'steps': 4},
      ],
      'Visa Application': [
        {'title': 'Tourist Visa Application', 'desc': 'Step-by-step tourist visa application process.', 'steps': 10},
        {'title': 'Business Visa Application', 'desc': 'Business visa requirements and application.', 'steps': 12},
        {'title': 'Student Visa Application', 'desc': 'Student visa application guide.', 'steps': 15},
      ],
      'Customs Declaration': [
        {'title': 'US Customs Declaration Form', 'desc': 'How to complete the US customs form.', 'steps': 7},
        {'title': 'International Customs Forms', 'desc': 'Customs forms for other countries.', 'steps': 6},
        {'title': 'Duty-Free Allowances', 'desc': 'Understanding duty-free limits.', 'steps': 5},
      ],
      'TSA PreCheck': [
        {'title': 'TSA PreCheck Application', 'desc': 'Complete TSA PreCheck enrollment process.', 'steps': 6},
        {'title': 'TSA PreCheck Interview', 'desc': 'What to expect during your interview.', 'steps': 4},
        {'title': 'TSA PreCheck Benefits', 'desc': 'Understanding TSA PreCheck benefits.', 'steps': 3},
      ],
      'Global Entry': [
        {'title': 'Global Entry Application', 'desc': 'Global Entry application process.', 'steps': 8},
        {'title': 'Global Entry Interview', 'desc': 'Interview preparation and process.', 'steps': 5},
        {'title': 'Global Entry vs TSA PreCheck', 'desc': 'Comparing the two programs.', 'steps': 4},
      ],
      'Travel Insurance': [
        {'title': 'Travel Insurance Basics', 'desc': 'Understanding travel insurance coverage.', 'steps': 6},
        {'title': 'Choosing Travel Insurance', 'desc': 'How to select the right policy.', 'steps': 8},
        {'title': 'Filing Insurance Claims', 'desc': 'How to file travel insurance claims.', 'steps': 7},
      ],
    };

    final walkthroughs = selectedDocument != null 
        ? allWalkthroughs[selectedDocument!] ?? []
        : [
            {'title': 'I-94 Arrival/Departure Form', 'desc': 'Step-by-step guide for filling out the I-94 form.', 'steps': 5},
            {'title': 'US Customs Declaration', 'desc': 'How to complete the US customs form.', 'steps': 7},
            {'title': 'Schengen Visa Form', 'desc': 'Tips for Schengen area entry forms.', 'steps': 9},
          ];

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedDocument ?? 'Document Walkthroughs'),
        actions: [
          if (selectedDocument != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const WalkthroughListPage()),
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedDocument != null) ...[
              Text(
                'Walkthroughs for $selectedDocument',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose a walkthrough to get started:',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ] else ...[
              const Text('Available Walkthroughs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              Text(
                'Select a document type or choose from general walkthroughs:',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
            const SizedBox(height: 16),
            Expanded(
              child: walkthroughs.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.description_outlined, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No walkthroughs available',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: walkthroughs.length,
                      itemBuilder: (context, index) {
                        final walkthrough = walkthroughs[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.description, color: Colors.blue.shade700),
                            ),
                            title: Text(walkthrough['title'] as String),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(walkthrough['desc'] as String),
                                const SizedBox(height: 8),
                                                                 Row(
                                   children: [
                                     Icon(Icons.format_list_numbered, size: 16, color: Colors.grey.shade600),
                                     const SizedBox(width: 4),
                                     Text('${walkthrough['steps']} steps'),
                                    const Spacer(),
                                    Text(
                                      'Tap to start',
                                      style: TextStyle(
                                        color: Colors.blue.shade600,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              // TODO: Navigate to walkthrough detail
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Starting walkthrough: ${walkthrough['title']}'),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
} 