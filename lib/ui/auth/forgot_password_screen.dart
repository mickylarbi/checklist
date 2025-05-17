import 'package:checklist/ui/auth/login_screen.dart';
import 'package:checklist/ui/shared/custom_filled_button.dart';
import 'package:checklist/ui/shared/email_text_form_field.dart';
import 'package:checklist/ui/shared/text_themes.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(24),
          children: [
            Center(child: Image.asset('assets/images/logo.png')),
            SizedBox(height: 30),
            Text(
              'Forgot password',
              style: headlineMedium(
                context,
              ).copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              'We\'ll send you an email to help you reset it',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            EmailTextFormField(),
            SizedBox(height: 20),
            CustomFilledButton(
              onPressed: () {
                //firebase login

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              },
              child: Text(
                'Reset',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
