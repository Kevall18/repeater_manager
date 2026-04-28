import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_routes.dart';
import '../../../commons/animations/app_animated_entry.dart';
import '../../../commons/app_scaffold/app_scaffold.dart';
import '../../../commons/validation/app_validators.dart';
import '../../../commons/widgets/app_loading_button.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_form_shell.dart';
import '../widgets/auth_page_header.dart';
import '../widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _autoValidate = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Login',
      body: AuthFormShell(
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthPageHeader(
                title: 'Welcome back',
                subtitle: 'Sign in to continue with your account.',
              ),
              const SizedBox(height: 24),
              AuthTextField(
                index: 0,
                controller: _emailController,
                label: 'Email',
                hint: 'Enter your email',
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.email_outlined,
                validator: AppValidators.email,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                index: 1,
                controller: _passwordController,
                label: 'Password',
                hint: 'Enter your password',
                isPassword: true,
                textInputAction: TextInputAction.done,
                prefixIcon: Icons.lock_outline,
                validator: AppValidators.password,
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 24),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state.message.isNotEmpty &&
                      state.status == AuthStatus.error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  return AppAnimatedEntry(
                    delay: const Duration(milliseconds: 260),
                    child: AppLoadingButton(
                      label: 'Login',
                      isLoading: state.status == AuthStatus.loading,
                      onPressed: _submit,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              AppAnimatedEntry(
                delay: const Duration(milliseconds: 340),
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.signup),
                  child: const Text('Create a new account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      setState(() {
        _autoValidate = true;
      });
      return;
    }

    final error = await context.read<AuthCubit>().signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );

    if (error != null && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }
}
