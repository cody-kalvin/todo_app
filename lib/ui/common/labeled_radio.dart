import 'package:flutter/material.dart';

class LabeledRadio<T> extends StatelessWidget {
  const LabeledRadio({
    this.label,
    this.padding = const EdgeInsets.all(0),
    this.groupValue,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final T groupValue;
  final T value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        if (value != groupValue) onChanged(value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Radio<T>(
              groupValue: groupValue,
              value: value,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: (T newValue) => onChanged(newValue),
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}
