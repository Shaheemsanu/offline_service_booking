import 'package:flutter/material.dart';
import 'package:offline_service_booking/src/domain/core/model/provider_model.dart';

class AddProviderBottomSheet extends StatefulWidget {
  final void Function(ProviderModel) onProviderAdded;
  final int pId;

  const AddProviderBottomSheet({
    super.key,
    required this.onProviderAdded,
    required this.pId,
  });

  @override
  State<AddProviderBottomSheet> createState() => _AddProviderBottomSheetState();
}

class _AddProviderBottomSheetState extends State<AddProviderBottomSheet> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactController = TextEditingController();

  void _submit() {
    final name = _nameController.text;
    final category = _categoryController.text;
    final location = _locationController.text;
    final contact = _contactController.text.trim();

    if (name.isEmpty ||
        category.isEmpty ||
        location.isEmpty ||
        contact.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final newProvider = ProviderModel(
      id: widget.pId.toString(),
      name: name,
      category: category,
      location: location,
      contact: contact,
    );

    widget.onProviderAdded(newProvider);
    Navigator.pop(context); // Close bottom sheet
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Service Provider',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: _contactController,
              decoration: InputDecoration(labelText: 'Contact'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _submit, child: Text('Add Provider')),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
