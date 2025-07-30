import 'package:flutter/material.dart';

class SeekerRequestHelpPage extends StatefulWidget {
  const SeekerRequestHelpPage({super.key});

  @override
  State<SeekerRequestHelpPage> createState() => _SeekerRequestHelpPageState();
}

class _SeekerRequestHelpPageState extends State<SeekerRequestHelpPage> {
  final _formKey = GlobalKey<FormState>();
  final _flightController = TextEditingController();
  final _departureController = TextEditingController();
  final _arrivalController = TextEditingController();
  DateTime? _selectedDate;
  List<String> _selectedLanguages = [];
  List<String> _selectedAssistance = [];

  final List<String> _languages = [
    'English', 'Spanish', 'French', 'German', 'Chinese', 'Hindi', 'Other'
  ];
  final List<String> _assistanceOptions = [
    'Immigration', 'Customs', 'Airport Navigation', 'Forms', 'Language', 'Emotional Support', 'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Help')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Tell us about your trip',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
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
                        controller: _departureController,
                        decoration: const InputDecoration(
                          labelText: 'Departure Airport',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.flight_takeoff),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'Enter departure airport' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _arrivalController,
                        decoration: const InputDecoration(
                          labelText: 'Arrival Airport',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.flight_land),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'Enter arrival airport' : null,
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
                const SizedBox(height: 16),
                const Text('Languages Needed'),
                Wrap(
                  spacing: 8,
                  children: _languages.map((lang) {
                    final selected = _selectedLanguages.contains(lang);
                    return FilterChip(
                      label: Text(lang),
                      selected: selected,
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            _selectedLanguages.add(lang);
                          } else {
                            _selectedLanguages.remove(lang);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text('Type of Assistance Needed'),
                Wrap(
                  spacing: 8,
                  children: _assistanceOptions.map((option) {
                    final selected = _selectedAssistance.contains(option);
                    return FilterChip(
                      label: Text(option),
                      selected: selected,
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            _selectedAssistance.add(option);
                          } else {
                            _selectedAssistance.remove(option);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Submit Request'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request submitted (UI only)!'), backgroundColor: Colors.blue),
      );
    }
  }

  @override
  void dispose() {
    _flightController.dispose();
    _departureController.dispose();
    _arrivalController.dispose();
    super.dispose();
  }
} 