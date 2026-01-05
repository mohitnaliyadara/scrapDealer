import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrapdealer/api_services/registration_api.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_style.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_filed.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _pwdVisible = false;
  bool _confirmPwdVisible = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _confirmPwdController = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _nameController.dispose();
    _phoneNumberController.dispose();
    _pwdController.dispose();
    _confirmPwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),

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
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 9,
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
                      Icons.person_add_alt_1,
                      size: 70,
                      color: AppColors.primaryColor,
                    ),



                    Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),



                    const Text(
                      "Register to continue",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),

                    const SizedBox(height: 30),

                    // Name
                    customTextFiled(
                      hintText: "Full Name",
                      controller: _nameController,
                      icon: Icons.person,
                      validation: (value) {
                        if (value!.isEmpty) {
                          return "Full name is required";
                        }
                        return null;
                      },
                    ),


                    // Email
                    customTextFiled(
                      hintText: "Email",
                      controller: _emailController,
                      icon: Icons.email,
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


                    // Phone Number
                    customTextFiled(
                      hintText: "Phone Number",
                      controller: _phoneNumberController,
                      textInputType: TextInputType.phone,
                      maxChar: 10,
                      icon: Icons.phone,
                      validation: (value) {
                        final phoneRegex = RegExp(r'^[0-9]{10}$');
                        if (value!.isEmpty) {
                          return "Phone number is required";
                        }
                        if (!phoneRegex.hasMatch(value)) {
                          return "Enter valid phone number";
                        }
                        return null;
                      },
                    ),

                    // Password
                    customTextFiled(
                      hintText: "Password",
                      controller: _pwdController,
                      obscureText: !_pwdVisible,
                      isPassword: true,
                      passwordVisible: () {
                        setState(() => _pwdVisible = !_pwdVisible);
                      },
                      icon: Icons.lock,
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

                    // Confirm Password
                    customTextFiled(
                      hintText: "Confirm Password",
                      controller: _confirmPwdController,
                      obscureText: !_confirmPwdVisible,
                      isPassword: true,
                      passwordVisible: () {
                        setState(
                              () => _confirmPwdVisible = !_confirmPwdVisible,
                        );
                      },
                      icon: Icons.lock_outline,
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return "Confirm Password is required";
                        }
                        if (value != _pwdController.text) {
                          return "Password and Confirm Password do not match";
                        }
                        return null;
                      },
                    ),



                    // Register Button
                    customButton(
                      text:  "Registration",
                      onPress: () {
                        if (_globalKey.currentState!.validate()) {
                          RegistrationApi.addDealer(
                            _nameController.text.trim(),
                            _emailController.text.trim(),
                            _phoneNumberController.text.trim(),
                            _pwdController.text.trim(),
                            context,
                          );
                        }
                      },
                      backcolor: AppColors.primaryColor,
                      textstyle: AppTextStyle.bold16(
                        color: AppColors.whiteColor,
                      ),
                      width: double.infinity,
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        InkWell(
                          onTap: () {
                            Get.off(() => LoginScreen());
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
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
