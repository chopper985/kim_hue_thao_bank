// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:kht_gold/core/navigator/app_router.dart';
import 'package:kht_gold/features/auth/presentation/cubit/auth_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<AuthCubit>().login();
            RootRoute().go(context);
          },
          child: const Text('Đăng nhập'),
        ),
      ),
    );
  }
}
