// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:kht_gold/core/app/colors/app_colors.dart';
import 'package:kht_gold/core/app/languages/data/localization.dart';
import 'package:kht_gold/core/constants/constants.dart';
import 'package:kht_gold/core/navigator/app_router.dart';
import 'package:kht_gold/features/auth/presentation/cubit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordHidden = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    context.read<AuthCubit>().login(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: colorText,
        iconTheme: const IconThemeData(color: colorText),
        title: Text(
          Strings.login.i18n,
          style: TextStyle(
            color: colorText,
            fontWeight: .w700,
            fontSize: 17.sp,
          ),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            RootRoute().go(context);
          }

          if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(Strings.loginFailed.i18n)));
          }
        },
        builder: (context, state) {
          final bool isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(18.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 18.sp),
                  Container(
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFCF2),
                      borderRadius: BorderRadius.circular(10.sp),
                      border: Border.all(
                        color: colorText.withValues(alpha: 0.45),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.diamond_outlined,
                          color: colorText,
                          size: 34.sp,
                        ),
                        SizedBox(height: 10.sp),
                        Text(
                          appName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF5A0500),
                            fontSize: 18.sp,
                            fontWeight: .w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.sp),
                  TextField(
                    controller: _usernameController,
                    enabled: !isLoading,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: Strings.username.i18n,
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.sp),
                  TextField(
                    controller: _passwordController,
                    enabled: !isLoading,
                    obscureText: _isPasswordHidden,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => isLoading ? null : _login(),
                    decoration: InputDecoration(
                      labelText: Strings.password.i18n,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                setState(() {
                                  _isPasswordHidden = !_isPasswordHidden;
                                });
                              },
                        icon: Icon(
                          _isPasswordHidden
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.sp),
                  SizedBox(
                    height: 38.sp,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5A0500),
                        foregroundColor: colorText,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.sp),
                        ),
                      ),
                      child: isLoading
                          ? SizedBox(
                              height: 16.sp,
                              width: 16.sp,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              Strings.login.i18n,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: .w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
