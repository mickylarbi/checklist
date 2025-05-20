import 'package:checklist/business_logic/auth/auth_service.dart';
import 'package:checklist/ui/shared/custom_filled_button.dart';
import 'package:checklist/ui/shared/dialogs.dart';
import 'package:checklist/ui/shared/email_text_form_field.dart';
import 'package:checklist/ui/shared/text_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toastification/toastification.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, this.email});
  final String? email;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final isLoadingNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    if (widget.email != null) {
      emailController.text = widget.email!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
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
              Form(
                key: formKey,
                child: EmailTextFormField(controller: emailController),
              ),
              SizedBox(height: 20),
              CustomFilledButton(
                onPressed: () async {
                  //firebase login

                  if (formKey.currentState?.validate() == true) {
                    isLoadingNotifier.value = true;

                    String? errorMessage =
                        await AuthService.sendPasswordResetEmail(
                          emailController.text,
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
                        Navigator.pop(context, true);
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
                      'Reset',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  },
                ),
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

    isLoadingNotifier.dispose();

    super.dispose();
  }
}
