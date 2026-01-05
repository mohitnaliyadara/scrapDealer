import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scrapdealer/screens/dashboard.dart';
import 'package:scrapdealer/screens/sign_in_screens/login_screen.dart';
import 'package:scrapdealer/widgets/custom_button.dart';

import '../api_services/dealer_profile_api.dart';
import '../utils/app_colors.dart';
import '../utils/app_style.dart';

class ProfileScreen extends StatefulWidget {
  final String dealerEmail;
  const ProfileScreen({super.key, required this.dealerEmail});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>?> profile;

  @override
  void initState() {
    super.initState();
    profile = DealerProfileApi.getProfile(widget.dealerEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        
        title: Text(
          "Dealer Profile",
          style: AppTextStyle.bold18(color: AppColors.whiteColor),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.whiteColor),
          onPressed: () => Get.offAll(()=>DealerDashboardScreen()),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: profile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "Profile not found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final dealer = snapshot.data!;

          return Center(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Avatar
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primaryColor.withOpacity(0.15),
                    child: Icon(
                      Icons.store,
                      size: 40,
                      color: AppColors.primaryColor,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Name
                  Text(dealer["dealer_name"], style: AppTextStyle.bold18()),

                  const SizedBox(height: 4),

                  /// Email
                  Text(
                    dealer["dealer_email"],
                    style: AppTextStyle.regular14(color: Colors.grey),
                  ),

                  const Divider(height: 30),

                  /// Phone
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        dealer["phone_number"],
                        style: AppTextStyle.medium16(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Logout
                  customButton(
                    text: "Logout",
                    onPress: () {
                      GetStorage().erase();
                      Get.offAll(() => LoginScreen());
                    },
                    backcolor: AppColors.primaryColor,
                    textstyle: AppTextStyle.bold16(color: AppColors.whiteColor),
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
