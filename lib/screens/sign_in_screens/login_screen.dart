import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scrapdealer/api_services/login_api.dart';
import 'package:scrapdealer/screens/sign_in_screens/registration_screen.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_style.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_filed.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withOpacity(0.85),
              AppColors.primaryColor.withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.90,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),

              child: Form(
                key: _globalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_pin,
                      size: 70,
                      color: AppColors.primaryColor,
                    ),

                    SizedBox(height: 12),

                    Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),

                    SizedBox(height: 6),

                    Text(
                      "Login to continue",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),

                    SizedBox(height: 30),

                    // Email
                    customTextFiled(
                      hintText: "Email",
                      controller: _emailController,
                      icon: Icons.email_outlined,
                      validation: (value) {
                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (value!.isEmpty) {
                          return "Email is required";
                        }
                        if (!emailRegex.hasMatch(value)) {
                          return "Enter a valid email address";
                        }
                        return null;
                      },
                    ),

                    // Password
                    customTextFiled(
                      hintText: "Password",
                      controller: _passwordController,
                      obscureText: _obscureText,
                      isPassword: true,
                      passwordVisible: () {
                        setState(() => _obscureText = !_obscureText);
                      },
                      icon: Icons.lock_outline,
                      validation: (value) {
                        if (value!.isEmpty) {
                          return "Password is required";
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.off(() => ForgotPassword());
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    // Login Button
                    customButton(
                      text: "Login",
                      onPress: () {
                        if (_globalKey.currentState!.validate()) {
                          LoginApi.checkLogin(
                            _emailController.text,
                            _passwordController.text,
                            context,
                          );
                        }
                      },
                      backcolor: AppColors.primaryColor,
                      textstyle: AppTextStyle.bold16(color: Colors.white),
                      width: double.infinity,
                    ),

                    SizedBox(height: 25),

                    Text("OR", style: AppTextStyle.semiBold16()),

                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? "),
                        InkWell(
                          onTap: () => Get.off(() => RegistrationScreen()),
                          child: Text(
                            "Signup",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
