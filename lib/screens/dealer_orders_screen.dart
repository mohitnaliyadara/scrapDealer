import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api_services/dealer_orders_api.dart';
import '../utils/app_colors.dart';
import '../utils/app_style.dart';
import 'dealer_order_details_screen.dart';

class DealerOrdersScreen extends StatefulWidget {
  final int shopId;
  const DealerOrdersScreen({super.key, required this.shopId});

  @override
  State<DealerOrdersScreen> createState() => _DealerOrdersScreenState();
}

class _DealerOrdersScreenState extends State<DealerOrdersScreen> {
  late Future<List<Map<String, dynamic>>> orders;

  @override
  void initState() {
    super.initState();
    orders = DealerOrdersApi.getOrders(widget.shopId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(onPressed: () {
          Get.back();
        }, icon: Icon(Icons.arrow_back_ios_new,color: AppColors.whiteColor,)),
        title: Text(
          "Pickup Requests",
          style: AppTextStyle.bold18(color: AppColors.whiteColor),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No pickup requests",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final list = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final order = list[index];

              return InkWell(
                onTap: () {
                  Get.to(
                        () => DealerOrderDetailsScreen(
                      orderId: int.parse(order["order_id"].toString()),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Order ID
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order #${order["order_id"]}",
                            style: AppTextStyle.bold16(),
                          ),
                          Text(
                            "₹ ${order["grand_total"]}",
                            style: AppTextStyle.bold16(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      /// Address
                      Text(
                        order["pickup_address"],
                        style: AppTextStyle.regular14(),
                      ),

                      const SizedBox(height: 6),

                      /// Date & Time
                      Text(
                        "Pickup: ${order["pickup_date"]} at ${order["pickup_time"]}",
                        style: AppTextStyle.medium14(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
