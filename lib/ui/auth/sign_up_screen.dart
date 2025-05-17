import 'package:checklist/ui/auth/login_screen.dart';
import 'package:checklist/ui/home/home_screen.dart';
import 'package:checklist/ui/shared/custom_filled_button.dart';
import 'package:checklist/ui/shared/custom_text_form_field.dart';
import 'package:checklist/ui/shared/custom_text_span.dart';
import 'package:checklist/ui/shared/email_text_form_field.dart';
import 'package:checklist/ui/shared/password_text_form_field.dart';
import 'package:checklist/ui/shared/text_themes.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
              'Login',
              style: headlineMedium(
                context,
              ).copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            CustomTextFormField(
              labelText: 'Name',
              prefixIcon: HugeIcon(
                icon: HugeIcons.strokeRoundedUser,
                color: Colors.grey,
                size: 16,
              ),
            ),
            SizedBox(height: 20),
            EmailTextFormField(),
            SizedBox(height: 20),
            PasswordTextFormField(),
            SizedBox(height: 20),

            SizedBox(height: 20),
            CustomFilledButton(
              onPressed: () {
                //firebase login

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false,
                );
              },
              child: Text(
                'Sign up',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            CustomTextSpan(
              firstText: 'Already have an account? ',
              secondText: 'Login',
              onActionPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
