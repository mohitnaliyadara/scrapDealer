import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrapdealer/res/app_route.dart';
import 'package:scrapdealer/screens/add_scrap_type_screen/shop_list_screen.dart';
import 'package:scrapdealer/screens/add_shop_screen.dart';
import 'package:scrapdealer/screens/profile_screen.dart';
import 'package:scrapdealer/screens/transection.dart';
import 'package:scrapdealer/screens/update_scrap/update_shop_list_screen.dart';
import 'package:scrapdealer/utils/app_colors.dart';
import 'package:scrapdealer/utils/app_style.dart';
import 'package:scrapdealer/widgets/custom_snakbar.dart';

class DealerDashboardScreen extends StatefulWidget {
  const DealerDashboardScreen({super.key});

  @override
  State<DealerDashboardScreen> createState() => _DealerDashboardScreenState();
}

class _DealerDashboardScreenState extends State<DealerDashboardScreen> {
  // 🔹 Dashboard menu items
  List<Map<String, dynamic>> get dealerTasks => [
    {
      "title": "Add Shop",
      "icon": Icons.store_mall_directory_outlined,
      "color": Colors.blueAccent,
      "onTap": () => Get.to(() => const AddShopScreen()),
    },
    {
      "title": "Add Scrap Type",
      "icon": Icons.category_outlined,
      "color": Colors.green,
      "onTap": () => Get.to(()=> ShopListScreen()),
    },
    {
      "title": "Update Scrap",
      "icon": Icons.update,
      "color": Colors.teal,
      "onTap": () => Get.to(() => UpdateShopListScreen()),
    },

    {
      "title": "Transactions",
      "icon": Icons.receipt_long_outlined,
      "color": Colors.purple,
      "onTap": () => Get.off(()=>DealerTransactionsScreen() ),
    },

    {
      "title": "Reports & Profit",
      "icon": Icons.bar_chart_outlined,
      "color": Colors.redAccent,
      "onTap": () => AppSnackbar.show("Feature coming soon!", SnackbarType.warning),
    },
    {
      "title": "Notifications",
      "icon": Icons.notifications_outlined,
      "color": Colors.amber,
      "onTap": () => AppSnackbar.show("Feature coming soon!", SnackbarType.warning),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withOpacity(0.8),
              AppColors.primaryColor.withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Dealer Dashboard",
                      style: AppTextStyle.bold24(color: Colors.white),
                    ),
                    InkWell(
                      onTap: (){
                        AppRoute.navigateOffAll(pageName: DealerProfileScreen());
                      },
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 🔹 Welcome message
                Text(
                  "Welcome back, Dealer 👋",
                  style: AppTextStyle.regular14(color: Colors.white70),
                ),
                const SizedBox(height: 25),

                // 🔹 Dashboard grid
                Expanded(
                  child: GridView.builder(
                    itemCount: dealerTasks.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemBuilder: (context, index) {
                      final item = dealerTasks[index];
                      return GestureDetector(
                        onTap: item['onTap'],
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: item['color'].withOpacity(0.1),
                                child: Icon(
                                  item['icon'],
                                  color: item['color'],
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item['title'],
                                textAlign: TextAlign.center,
                                style: AppTextStyle.semiBold14(color: AppColors.blackColor),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
