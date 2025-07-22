// create global widgets in core folder like this

import 'package:offline_service_booking/src/presentation/core/theme/typography.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({Key? key, required this.text, this.onPressed})
    : super(key: key);

  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text, style: AppTypography.buttonTextStyle),
    );
  }
}
