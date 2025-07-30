import 'package:flutter/material.dart';

class NavigatorOnboardingScreen extends StatefulWidget {
  const NavigatorOnboardingScreen({super.key});

  @override
  State<NavigatorOnboardingScreen> createState() => _NavigatorOnboardingScreenState();
}

class _NavigatorOnboardingScreenState extends State<NavigatorOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  List<String> _selectedLanguages = [];
  List<String> _selectedExpertise = [];
  int _completedTrips = 0;
  bool _isVerified = false;

  final List<String> _availableLanguages = [
    'English', 'Spanish', 'French', 'German', 'Italian', 'Portuguese',
    'Chinese', 'Japanese', 'Korean', 'Arabic', 'Hindi', 'Russian'
  ];

  final List<String> _expertiseOptions = [
    'Immigration Process', 'Customs Declaration', 'Airport Navigation',
    'Document Assistance', 'Language Translation', 'Emergency Support',
    'Flight Information', 'Transportation Help', 'Cultural Guidance',
    'Medical Assistance', 'Legal Documentation', 'Travel Planning'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigator Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildPersonalInfoSection(),
                const SizedBox(height: 24),
                _buildLanguageSection(),
                const SizedBox(height: 24),
                _buildExpertiseSection(),
                const SizedBox(height: 24),
                _buildExperienceSection(),
                const SizedBox(height: 24),
                _buildVerificationSection(),
                const SizedBox(height: 32),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(
            Icons.navigation,
            size: 50,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Share your travel expertise',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Help others by sharing your knowledge and experience',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number (Optional)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildLanguageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Languages You Can Help With',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select languages you can assist with',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableLanguages.map((language) {
            final isSelected = _selectedLanguages.contains(language);
            return FilterChip(
              label: Text(language),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedLanguages.add(language);
                  } else {
                    _selectedLanguages.remove(language);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExpertiseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Areas of Expertise',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select areas where you can provide assistance',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        ..._expertiseOptions.map((option) {
          final isSelected = _selectedExpertise.contains(option);
          return CheckboxListTile(
            title: Text(option),
            value: isSelected,
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  _selectedExpertise.add(option);
                } else {
                  _selectedExpertise.remove(option);
                }
              });
            },
          );
        }),
      ],
    );
  }

  Widget _buildExperienceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Travel Experience',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('Number of international trips completed: '),
            Expanded(
              child: DropdownButtonFormField<int>(
                value: _completedTrips,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: List.generate(21, (index) {
                  if (index == 0) {
                    return const DropdownMenuItem(
                      value: 0,
                      child: Text('0-5'),
                    );
                  } else if (index == 1) {
                    return const DropdownMenuItem(
                      value: 1,
                      child: Text('6-10'),
                    );
                  } else if (index == 2) {
                    return const DropdownMenuItem(
                      value: 2,
                      child: Text('11-20'),
                    );
                  } else if (index == 3) {
                    return const DropdownMenuItem(
                      value: 3,
                      child: Text('20+'),
                    );
                  }
                  return DropdownMenuItem(
                    value: index,
                    child: Text('${index * 5 + 1}-${(index + 1) * 5}'),
                  );
                }),
                onChanged: (value) {
                  setState(() {
                    _completedTrips = value ?? 0;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVerificationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verification',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Would you like to be verified as a trusted Navigator?',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Get Verified'),
          subtitle: const Text('Verified Navigators get priority matching'),
          value: _isVerified,
          onChanged: (value) {
            setState(() {
              _isVerified = value;
            });
          },
        ),
        if (_isVerified) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verification Process:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '• Government ID verification\n'
                  '• Background check\n'
                  '• Reference checks\n'
                  '• Community feedback review',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Create Navigator Profile',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Create Navigator profile and navigate to main app
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Navigator profile created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // For now, just go back to the main screen
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
} 