import 'package:checklist/business_logic/auth/auth_service.dart';
import 'package:checklist/ui/auth/forgot_password_screen.dart';
import 'package:checklist/ui/auth/sign_up_screen.dart';
import 'package:checklist/ui/home/home_screen.dart';
import 'package:checklist/ui/shared/custom_filled_button.dart';
import 'package:checklist/ui/shared/custom_text_button.dart';
import 'package:checklist/ui/shared/custom_text_span.dart';
import 'package:checklist/ui/shared/dialogs.dart';
import 'package:checklist/ui/shared/email_text_form_field.dart';
import 'package:checklist/ui/shared/password_text_form_field.dart';
import 'package:checklist/ui/shared/text_themes.dart';
import 'package:checklist/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toastification/toastification.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                'Login',
                style: headlineMedium(
                  context,
                ).copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 30),
              EmailTextFormField(controller: emailController),
              SizedBox(height: 20),
              PasswordTextFormField(controller: passwordController),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: CustomTextButton(
                  onPressed: () async {
                    bool? emailSent = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen(),
                      ),
                    );

                    if (emailSent == true && context.mounted) {
                      showToastNotification(
                        context,
                        'Kindly check your email inbox for instructions to reset your password',
                      );
                    }
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              CustomFilledButton(
                onPressed: () async {
                  //firebase login

                  if (formKey.currentState?.validate() == true) {
                    isLoadingNotifier.value = true;

                    String? errorMessage = await AuthService.login(
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
                      'Login',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),

              CustomTextSpan(
                firstText: 'Don\'t have an account? ',
                secondText: 'Sign up',
                onActionPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
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
    emailController.dispose();
    passwordController.dispose();

    isLoadingNotifier.dispose();

    super.dispose();
  }
}
