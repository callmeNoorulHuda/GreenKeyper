import 'package:flutter/material.dart';
import '../common/custom_button.dart';

class AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> fields;
  final String buttonText;
  final VoidCallback onSubmit;
  final bool isLoading;
  final Widget? additionalWidget;

  const AuthForm({
    super.key,
    required this.formKey,
    required this.fields,
    required this.buttonText,
    required this.onSubmit,
    this.isLoading = false,
    this.additionalWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          ...fields.map(
            (field) => Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: field,
            ),
          ),
          if (additionalWidget != null) ...[
            additionalWidget!,
            const SizedBox(height: 20),
          ],
          const SizedBox(height: 30),
          CustomButton(
            text: buttonText,
            onPressed: onSubmit,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
