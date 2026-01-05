import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api_services/dealer_completed_pickups_api.dart';
import '../utils/app_colors.dart';
import '../utils/app_style.dart';

class DealerCompletedPickupsScreen extends StatefulWidget {
  final int shopId;
  const DealerCompletedPickupsScreen({super.key, required this.shopId});

  @override
  State<DealerCompletedPickupsScreen> createState() =>
      _DealerCompletedPickupsScreenState();
}

class _DealerCompletedPickupsScreenState
    extends State<DealerCompletedPickupsScreen> {
  late Future<List<Map<String, dynamic>>> completedOrders;

  @override
  void initState() {
    super.initState();
    completedOrders =
        DealerCompletedPickupsApi.getCompletedPickups(widget.shopId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "Completed Pickups",
          style: AppTextStyle.bold18(color: AppColors.whiteColor),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.whiteColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: completedOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No completed pickups",
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

              return Container(
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
                    /// Order ID & Amount
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

                    const SizedBox(height: 6),

                    /// Status
                    Row(
                      children: const [
                        Icon(Icons.check_circle,
                            size: 16, color: Colors.green),
                        SizedBox(width: 6),
                        Text(
                          "Completed",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
