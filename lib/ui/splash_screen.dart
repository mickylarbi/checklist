import 'package:checklist/business_logic/cubits/task/task_cubit.dart';
import 'package:checklist/ui/auth/login_screen.dart';
import 'package:checklist/ui/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  FirebaseAuth.instance.currentUser != null
                      ? BlocProvider(
                        create: (context) => TaskCubit(),
                        child: HomeScreen(),
                      )
                      : LoginScreen(),
        ),
      );
    });

    return Scaffold(body: Center(child: Image.asset('assets/images/logo.png')));
  }
}
