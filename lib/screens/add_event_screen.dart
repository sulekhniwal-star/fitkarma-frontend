import 'package:flutter/material.dart';
import '../services/pocketbase_service.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _nameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _eventType = 'marriage';

  Future<void> _saveEvent() async {
    final authId = PocketBaseService.pb.authStore.model?.id;
    if (authId == null) return;

    await PocketBaseService.pb
        .collection('user_events')
        .create(
          body: {
            'user': authId,
            'event_date': _selectedDate.toIso8601String(),
            'event_name': _nameController.text,
            'event_type': _eventType,
          },
        );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Plan for Special Day")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Event Name (e.g. Brother's Wedding)",
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _eventType,
              items: ['marriage', 'festival', 'party', 'travel']
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (val) => setState(() => _eventType = val!),
              decoration: const InputDecoration(labelText: "Event Type"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) setState(() => _selectedDate = date);
              },
              child: Text(
                "Select Date: ${_selectedDate.toLocal()}".split(' ')[0],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.orange,
              ),
              onPressed: _saveEvent,
              child: const Text("Add to Diet Timeline"),
            ),
          ],
        ),
      ),
    );
  }
}
