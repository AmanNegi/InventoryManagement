import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inv_mgmt_client/core/auth/application/auth.dart';
import 'package:inv_mgmt_client/core/home/presentation/home_page.dart';
import 'package:inv_mgmt_client/core/settings/presentation/settings_page.dart';
import 'package:inv_mgmt_client/globals.dart';
import 'package:inv_mgmt_client/widgets/action_button.dart';
import 'package:inv_mgmt_client/widgets/custom_text_field.dart';
import 'package:inv_mgmt_client/widgets/loading_widget.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<AuthPage> {
  late AuthManager _authManager;
  String email = "", password = "";

  @override
  void initState() {
    _authManager = AuthManager(context, ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingWidget(
        isLoading: _authManager.isLoading,
        child: _buildLoginPage(context),
      ),
    );
  }

  _buildLoginPage(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          const SizedBox(height: kToolbarHeight),
          SizedBox(height: 0.025 * getHeight(context)),
          const Center(
            child: Text(
              "InvMgmt",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Center(
            child: Text(
              "Hisab karo",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(height: 0.025 * getHeight(context)),
          CustomTextField(
            value: email,
            onChanged: (v) => email = v,
            label: "Email",
          ),
          const SizedBox(height: 10),
          CustomTextField(
            value: password,
            isPassword: true,
            onChanged: (v) => password = v,
            label: "Password",
          ),
          SizedBox(height: 0.3 * getHeight(context)),
          ActionButton(
            isFilled: true,
            onPressed: () async {
              if (email.trim().isEmpty) {
                showToast("Enter a valid email");
                return;
              }

              if (password.trim().isEmpty) {
                showToast("Enter a valid password");
                return;
              }

              var res = await _authManager.loginUsingEmailPassword(
                email: email.trim(),
                password: password.trim(),
              );

              if (res == 1 && mounted) {
                goToPage(context, const HomePage(), clearStack: true);
              }
            },
            text: "Log in",
          ),
          SizedBox(height: 0.015 * getHeight(context)),
        ],
      ),
    );
  }
}
