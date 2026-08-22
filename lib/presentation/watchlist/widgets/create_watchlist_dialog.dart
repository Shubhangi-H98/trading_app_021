import 'package:flutter/material.dart';

class CreateWatchlistDialog extends StatefulWidget {
  final String? initialName;
  final Function(String name) onSave;

  const CreateWatchlistDialog({super.key, this.initialName, required this.onSave});

  @override
  State<CreateWatchlistDialog> createState() => _CreateWatchlistDialogState();
}

class _CreateWatchlistDialogState extends State<CreateWatchlistDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialName != null;

    return AlertDialog(
      title: Text(isEditing ? 'Rename Watchlist' : 'Create Watchlist'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'e.g., Banking, Tech, Top 5',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              widget.onSave(_controller.text.trim());
              Navigator.pop(context);
            }
          },
          child: Text(isEditing ? 'Save' : 'Create'),
        ),
      ],
    );
  }
}