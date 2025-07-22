import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({super.key, required this.onPressed});
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red),
      onPressed: () {
        // Optional: confirm deletion
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Delete Booking'),
            content: Text('Are you sure you want to delete this booking?'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(onPressed: onPressed, child: Text('Delete')),
            ],
          ),
        );
      },
    );
  }
}
