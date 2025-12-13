import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrapdealer/controller/controller.dart';
import 'package:scrapdealer/res/app_route.dart';
import 'package:scrapdealer/screens/add_scrap_type_screen/add_scrap_type_screen.dart';
import 'package:scrapdealer/screens/dashboard.dart';
import 'package:scrapdealer/screens/update_scrap/update_scrap_screen.dart';
import 'package:scrapdealer/utils/app_colors.dart';
import 'package:scrapdealer/utils/app_style.dart';

class UpdateShopListScreen extends StatefulWidget {
  const UpdateShopListScreen({super.key});

  @override
  State<UpdateShopListScreen> createState() => _UpdateShopListScreenState();
}

class _UpdateShopListScreenState extends State<UpdateShopListScreen> {
  late Future<List<Map<String, dynamic>>> shops;

  @override
  void initState() {
    super.initState();
    shops = Controller.getShops();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          AppRoute.navigateOffAll(pageName: DealerDashboardScreen());
        }, icon: Icon(Icons.arrow_back_ios_new)),
        title: Text("Select Shop",style: AppTextStyle.bold22(color: AppColors.whiteColor),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withOpacity(0.8),
              AppColors.primaryColor.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: shops,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Shops Found",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                } else {
                  final shopList = snapshot.data!;
                  return GridView.builder(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    itemCount: shopList.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemBuilder: (context, index) {
                      final item = shopList[index];
                      return InkWell(
                        onTap: () {
                          Get.to(UpdateScrapScreen(
                            shopName: item["shopName"],
                          ));
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor:
                                  AppColors.primaryColor.withOpacity(0.3),
                                  child: Icon(
                                    Icons.storefront,
                                    color: AppColors.primaryColor,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  item['shopName'] ?? 'Unnamed Shop',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.semiBold14(
                                    color: AppColors.blackColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['city'] ?? '',
                                  style: AppTextStyle.regular12(
                                    color: AppColors.darkGreyColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
