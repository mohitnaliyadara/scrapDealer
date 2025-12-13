import 'package:flutter/material.dart';
import '../../api_services/forgot_password.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_style.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_filed.dart';

class NewPassword extends StatefulWidget {
  final String email;
  const NewPassword({super.key, required this.email});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
     ForgotPasswordApi.newPassword(_newPassController.text, widget.email, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Password"),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: AppColors.primaryColor,

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,

          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Set New Password",
                  style: AppTextStyle.bold18(color: AppColors.primaryColor),
                ),

                const SizedBox(height: 20),


                customTextFiled(
                  hintText: "New Password",
                  controller: _newPassController,
                  icon: Icons.lock,
                  isPassword: true,
                  obscureText: !_newPasswordVisible,
                  passwordVisible: () {
                    setState(() => _newPasswordVisible = !_newPasswordVisible);
                  },
                  validation: (value) {
                    final passwordRegex = RegExp(
                      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
                    );
                    if (value!.isEmpty) {
                      return "Password is required";
                    }
                    if (!passwordRegex.hasMatch(value)) {
                      return "Password must contain uppercase, lowercase, number and special character at least 8 Character";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),


                customTextFiled(
                  hintText: "Confirm Password",
                  controller: _confirmPassController,
                  icon: Icons.lock_outline,
                  isPassword: true,
                  obscureText: !_confirmPasswordVisible,
                  passwordVisible: () {
                    setState(() => _confirmPasswordVisible = !_confirmPasswordVisible);
                  },
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirm Password is required";
                    }
                    if (value != _newPassController.text) {
                      return "Password and Confirm Password do not match";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                customButton(
                  text: "Update Password",
                  backcolor: AppColors.primaryColor,
                  textstyle: AppTextStyle.bold16(color: Colors.white),
                  width: double.infinity,
                  onPress: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
