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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _autoValidate = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Sign Up',
      body: AuthFormShell(
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AuthPageHeader(
                  title: 'Create account',
                  subtitle: 'Fill in the details below to register.',
                ),
                const SizedBox(height: 24),
                AuthTextField(
                  index: 0,
                  controller: _nameController,
                  label: 'Name',
                  hint: 'Enter your full name',
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.person_outline,
                  validator: (value) =>
                      AppValidators.requiredTrimmed(value, fieldName: 'Name'),
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  index: 1,
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.email_outlined,
                  validator: AppValidators.email,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  index: 2,
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Create a password',
                  isPassword: true,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.lock_outline,
                  validator: AppValidators.password,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  index: 3,
                  controller: _confirmPasswordController,
                  label: 'Confirm password',
                  hint: 'Re-enter your password',
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  prefixIcon: Icons.lock_reset_outlined,
                  validator: (value) => AppValidators.confirmPassword(
                    value,
                    _passwordController.text,
                  ),
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
                      delay: const Duration(milliseconds: 380),
                      child: AppLoadingButton(
                        label: 'Sign Up',
                        isLoading: state.status == AuthStatus.loading,
                        onPressed: _submit,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                AppAnimatedEntry(
                  delay: const Duration(milliseconds: 460),
                  child: TextButton(
                    onPressed: () => context.go(AppRoutes.login),
                    child: const Text('Back to login'),
                  ),
                ),
              ],
            ),
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

    final error = await context.read<AuthCubit>().signUp(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
        );

    if (error != null && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }
}
