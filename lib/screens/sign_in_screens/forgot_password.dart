import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api_services/forgot_password.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_style.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_filed.dart';
import 'login_screen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Request Submitted Successfully")),
      );
      ForgotPasswordApi.forgotPassword(_emailController.text, _phoneController.text, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,

      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Forgot Password",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () => Get.off(() => LoginScreen()),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Form(
            key: _formKey,

            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // Title
                  const Text(
                    "Recover Your Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Enter your registered email and phone number to reset your password.",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),

                  const SizedBox(height: 25),

                  // Email Field
                  customTextFiled(
                    hintText:
                       "Email",
                     validation: (value) {
                      if (value!.isEmpty) return "Email is required";

                      final emailRegex =
                      RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');

                      if (!emailRegex.hasMatch(value)) {
                        return "Enter a valid email";
                      }
                      return null;
                    }, controller: _emailController,
                  ),

                  const SizedBox(height: 20),

                  // Phone Field
                  customTextFiled(
                    hintText: "Phone",
                    controller: _phoneController,
                    textInputType: TextInputType.phone,
                    maxChar: 10,
                    validation: (value) {
                      if (value!.isEmpty) return "Phone number required";
                      if (value.length != 10) return "Phone must be 10 digits";
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return "Only numbers allowed";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  customButton(
                    text: "Submit",
                    onPress: _submit,
                    backcolor: AppColors.primaryColor,
                    width: double.infinity,
                    textstyle: AppTextStyle.semiBold20(color: AppColors.whiteColor)
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
