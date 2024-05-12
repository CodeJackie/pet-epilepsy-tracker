// CustomChipsInput.dart
import 'package:flutter/material.dart';
import '/models/trigger.dart';  // Ensure you import your Trigger model

class CustomChipsInput extends StatefulWidget {
  final List<Trigger> initialTriggers;
  final Function(List<Trigger>) onChanged;

  CustomChipsInput({Key? key, required this.initialTriggers, required this.onChanged}) : super(key: key);

  @override
  _CustomChipsInputState createState() => _CustomChipsInputState();
}

class _CustomChipsInputState extends State<CustomChipsInput> {
  late List<Trigger> _selectedTriggers;

  @override
  void initState() {
    super.initState();
    _selectedTriggers = List.from(widget.initialTriggers);  // Make a copy of the initial list
  }

  void _addTrigger(Trigger trigger) {
    if (!_selectedTriggers.any((t) => t.triggerName == trigger.triggerName)) {
      setState(() {
        _selectedTriggers.add(trigger);
      });
      widget.onChanged(List.from(_selectedTriggers));  // Pass a copy if needed
    }
  }

  void _removeTrigger(Trigger trigger) {
    setState(() {
      _selectedTriggers.removeWhere((t) => t.triggerName == trigger.triggerName);
    });
    widget.onChanged(List.from(_selectedTriggers));  // Pass a copy if needed
  }

  Widget _buildChip(Trigger trigger) {
    return Chip(
      label: Text(trigger.triggerName),
      onDeleted: () => _removeTrigger(trigger),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8.0,
          children: _selectedTriggers.map(_buildChip).toList(),
        ),
        TextField(
          onSubmitted: (value) {
            _addTrigger(Trigger(triggerName: value));  // Adjust as necessary
          },
          decoration: InputDecoration(
            labelText: 'Add a trigger',
            suffixIcon: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
