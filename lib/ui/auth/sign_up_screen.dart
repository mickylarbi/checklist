import 'package:checklist/business_logic/auth/auth_service.dart';
import 'package:checklist/ui/auth/login_screen.dart';
import 'package:checklist/ui/home/home_screen.dart';
import 'package:checklist/ui/shared/custom_filled_button.dart';
import 'package:checklist/ui/shared/custom_text_form_field.dart';
import 'package:checklist/ui/shared/custom_text_span.dart';
import 'package:checklist/ui/shared/dialogs.dart';
import 'package:checklist/ui/shared/email_text_form_field.dart';
import 'package:checklist/ui/shared/password_text_form_field.dart';
import 'package:checklist/ui/shared/text_themes.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:toastification/toastification.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final isLoadingNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(24),
            children: [
              Center(child: Image.asset('assets/images/logo.png')),
              SizedBox(height: 30),
              Text(
                'Sign up',
                style: headlineMedium(
                  context,
                ).copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              CustomTextFormField(
                controller: nameController,
                labelText: 'Name',
                prefixIcon: HugeIcon(
                  icon: HugeIcons.strokeRoundedUser,
                  color: Colors.grey,
                  size: 16,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }

                  return null;
                },
              ),
              SizedBox(height: 20),
              EmailTextFormField(controller: emailController),
              SizedBox(height: 20),
              PasswordTextFormField(controller: passwordController),
              SizedBox(height: 40),

              CustomFilledButton(
                onPressed: () async {
                  //firebase sign up

                  if (formKey.currentState?.validate() == true) {
                    isLoadingNotifier.value = true;

                    String? errorMessage = await AuthService.signUp(
                      nameController.text,
                      emailController.text,
                      passwordController.text,
                    );
                    
                    isLoadingNotifier.value = false;

                    if (context.mounted) {
                      if (errorMessage != null) {
                        showToastNotification(
                          context,
                          errorMessage,
                          type: ToastificationType.error,
                        );
                      } else {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (route) => false,
                        );
                      }
                    }

                  }
                },
                child: ValueListenableBuilder(
                  valueListenable: isLoadingNotifier,
                  builder: (context, value, child) {
                    if (value) {
                      return SpinKitDoubleBounce(size: 14, color: Colors.white);
                    }
                    return Text(
                      'Sign up',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  },
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
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    isLoadingNotifier.dispose();

    super.dispose();
  }
}
