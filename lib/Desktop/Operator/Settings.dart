import 'package:flutter/material.dart';

class CheckboxWithLabel extends StatefulWidget {
  final String label;
  final Function(bool isChecked) onChanged;

  CheckboxWithLabel({
    required this.label,
    required this.onChanged,
  });

  @override
  _CheckboxWithLabelState createState() => _CheckboxWithLabelState();
}

class _CheckboxWithLabelState extends State<CheckboxWithLabel> {
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
          widget.onChanged(_isChecked);
        });
      },
      child: Row(
        children: [
          Text(widget.label),
          Checkbox(
            value: _isChecked,
            onChanged: (bool? value) {
              setState(() {
                _isChecked = value!;
                widget.onChanged(_isChecked);
              });
            },
          ),

        ],
      ),
    );
  }
}

class DropdownCheckbox extends StatefulWidget {
  final List<String> options;

  DropdownCheckbox({required this.options});

  @override
  _DropdownCheckboxState createState() => _DropdownCheckboxState();
}

class _DropdownCheckboxState extends State<DropdownCheckbox> {
  List<String> _selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select options:'),
          DropdownButtonFormField<String>(
            value: null,
            items: widget.options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: CheckboxWithLabel(
                  label: value,
                  onChanged: (bool isChecked) {
                    setState(() {
                      if (isChecked) {
                        _selectedItems.add(value);
                      } else {
                        _selectedItems.remove(value);
                      }
                    });
                  },
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              // do something with selected value
            },
          ),
        ],
      ),
    );
  }
}
