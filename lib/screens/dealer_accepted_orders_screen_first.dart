import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrapdealer/api_services/delete_shop_api.dart';
import 'package:scrapdealer/api_services/get_shop_api.dart';
import 'package:scrapdealer/screens/add_scrap_type_screen/add_scrap_type_screen.dart';
import 'package:scrapdealer/screens/add_scrap_type_screen/update_shop_screen.dart';
import 'package:scrapdealer/screens/dashboard.dart';
import 'package:scrapdealer/screens/dealer_accepted_orders_screen.dart';
import 'package:scrapdealer/screens/dealer_completed_pickups_screen.dart';
import 'package:scrapdealer/screens/dealer_orders_screen.dart';
import '../../controller/controller.dart';
import '../../model/ShopListModel.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_style.dart';

class DealerAcceptedOrdersScreenFirst extends StatefulWidget {
  const DealerAcceptedOrdersScreenFirst({super.key});

  @override
  State<DealerAcceptedOrdersScreenFirst> createState() => _DealerAcceptedOrdersScreenFirstState();
}

class _DealerAcceptedOrdersScreenFirstState extends State<DealerAcceptedOrdersScreenFirst> {
  late Future<List<ShopData>> shopList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shopList = GetShopListApi.getShopList(Controller.loginEmail);
  }

  void refreshPage() {
    setState(() {
      shopList = GetShopListApi.getShopList(Controller.loginEmail);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "Shop List",
          style: AppTextStyle.bold22(color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DealerDashboardScreen()),
            );
          },
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.whiteColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
        child: FutureBuilder(
          future: shopList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return Center(child: Text("No Data Found"));
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final shop = snapshot.data![index];
                  return InkWell(
                    onTap: () {
                      Get.to(
                            () => DealerAcceptedOrdersScreen(
                          shopId: int.parse(shop.id!),
                        ),
                      );
                    },

                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.storefront_rounded,
                              color: Colors.green,
                              size: 32,
                            ),
                          ),

                          SizedBox(height: 12),

                          Text(
                            shop.shopname ?? "Shop Name",
                            textAlign: TextAlign.center,
                            style: AppTextStyle.bold18(color: Colors.black87),
                          ),

                          SizedBox(height: 6),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.redAccent,
                              ),
                              SizedBox(width: 4),
                              Text(
                                shop.city ?? "City",
                                style: AppTextStyle.bold14(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<dynamic> showInfo(ShopData shop) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: EdgeInsets.only(top: 20, left: 20, right: 20),
          contentPadding: EdgeInsets.only(left: 20, right: 20, bottom: 20),

          title: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.green, size: 26),
              SizedBox(width: 10),
              Text(
                "Choose Action",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(),

              ListTile(
                leading: Icon(Icons.edit, color: Colors.blue, size: 28),
                title: Text(
                  "Edit Shop",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Get.offAll(() => UpdateShopScreen(shop: shop));
                },
              ),

              ListTile(
                leading: Icon(Icons.delete, color: Colors.red, size: 28),
                title: Text(
                  "Delete Shop",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Get.back();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Delete", style: AppTextStyle.bold18()),
                        content: Text(
                          "Are you sure, You want Delete ${shop.shopname} shop",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              DeleteShopApi.deleteShop(
                                shop.id.toString(),
                                context,
                              );
                              Get.back();
                              refreshPage();
                            },
                            child: Text("Yes"),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text("No"),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
