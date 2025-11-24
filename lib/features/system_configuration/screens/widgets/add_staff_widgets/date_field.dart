import 'package:flutter/material.dart';

class DateField extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(BuildContext) onDateSelected;
  final bool isRequired;

  const DateField({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onDateSelected(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Hire Date${isRequired ? ' *' : ''}',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          prefixIcon: Icon(Icons.calendar_today, color: Colors.grey[600]),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              selectedDate == null
                  ? 'Select a date'
                  : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
              style: TextStyle(
                color: selectedDate == null ? Colors.grey[500] : Colors.grey[800],
                fontSize: 16,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}