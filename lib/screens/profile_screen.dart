import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scrapdealer/res/app_route.dart';
import 'package:scrapdealer/screens/dashboard.dart';
import 'package:scrapdealer/screens/sign_in_screens/login_screen.dart';
import 'package:scrapdealer/utils/app_colors.dart';
import 'package:scrapdealer/utils/app_style.dart';
import 'package:scrapdealer/widgets/custom_button.dart';
import 'package:scrapdealer/widgets/custom_snakbar.dart';

class DealerProfileScreen extends StatefulWidget {
  const DealerProfileScreen({super.key});

  @override
  State<DealerProfileScreen> createState() => _DealerProfileScreenState();
}

class _DealerProfileScreenState extends State<DealerProfileScreen> {
  bool isLoading = true;
  Map<String, dynamic>? dealerData;
  int shopCount = 0;

  @override
  void initState() {
    super.initState();
    loadDealerProfile();
  }

  /// 🔹 Fetch dealer data + shop count
  Future<void> loadDealerProfile() async {
    try {
      final dealerEmail = GetStorage().read("dealerEmail");
      if (dealerEmail == null) {
        AppSnackbar.show("No dealer logged in", SnackbarType.error);
        return;
      }

      // Fetch dealer details
      final dealerDoc = await FirebaseFirestore.instance
          .collection("dealer")
          .doc(dealerEmail)
          .get();

      // Fetch total shops count
      final shopSnapshot = await FirebaseFirestore.instance
          .collection("dealer")
          .doc(dealerEmail)
          .collection("shops")
          .get();

      setState(() {
        dealerData = dealerDoc.data();
        shopCount = shopSnapshot.docs.length;
        isLoading = false;
      });
    } catch (e) {
      AppSnackbar.show("Error loading profile: $e", SnackbarType.error);
      setState(() => isLoading = false);
    }
  }

  /// 🔹 Edit profile info
  void showEditDialog() {
    final nameController = TextEditingController(
      text: dealerData?["name"] ?? "",
    );
    final phoneController = TextEditingController(
      text: dealerData?["phone"] ?? "",
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "Edit Profile",
          style: AppTextStyle.bold18(color: AppColors.primaryColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                prefixIcon: Icon(Icons.phone),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              final dealerEmail = GetStorage().read("dealerEmail");
              try {
                await FirebaseFirestore.instance
                    .collection("dealer")
                    .doc(dealerEmail)
                    .update({
                      "name": nameController.text.trim(),
                      "phone": phoneController.text.trim(),
                    });
                Navigator.pop(context);
                AppSnackbar.show(
                  "Profile updated successfully",
                  SnackbarType.success,
                );
                loadDealerProfile();
              } catch (e) {
                AppSnackbar.show(
                  "Error updating profile: $e",
                  SnackbarType.error,
                );
              }
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(onPressed: (){
          AppRoute.navigateOffAll(pageName: DealerDashboardScreen());
        }, icon: Icon(Icons.arrow_back_ios_new,color: AppColors.whiteColor,)),
        title: Text(
          "Dealer Profile",
          style: AppTextStyle.bold18(color: Colors.white),
        ),
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
        child: SafeArea(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: AppColors.primaryColor.withOpacity(
                            0.2,
                          ),
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          dealerData?["name"] ?? "Unknown Dealer",
                          style: AppTextStyle.bold20(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          dealerData?["email"] ?? "No Email",
                          style: AppTextStyle.regular14(
                            color: AppColors.darkGreyColor,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Phone: ${dealerData?["phone"] ?? "N/A"}",
                          style: AppTextStyle.regular14(
                            color: AppColors.darkGreyColor,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: AppColors.greyColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Shops",
                                style: AppTextStyle.bold16(
                                  color: AppColors.blackColor,
                                ),
                              ),
                              Text(
                                "$shopCount",
                                style: AppTextStyle.bold18(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        customButton(
                          text:
                            "Edit Profile",

                          onPress: showEditDialog,
                        ),
                        const SizedBox(height: 15),
                        customButton(
                          text:
                            "Logout",

                          onPress: () {
                            GetStorage().erase();
                            AppRoute.navigateOffAll(pageName: LoginScreen());
                            AppSnackbar.show(
                              "Logged out successfully",
                              SnackbarType.success,
                            );
                          },
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
