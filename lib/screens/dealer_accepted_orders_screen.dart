import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrapdealer/api_services/update_order_status_api.dart';
import 'package:scrapdealer/screens/dealer_order_details_screen.dart';


import '../api_services/dealer_accepted_orders_api.dart';
import '../utils/app_colors.dart';
import '../utils/app_style.dart';

class DealerAcceptedOrdersScreen extends StatefulWidget {
  final int shopId;
  const DealerAcceptedOrdersScreen({super.key, required this.shopId});

  @override
  State<DealerAcceptedOrdersScreen> createState() =>
      _DealerAcceptedOrdersScreenState();
}

class _DealerAcceptedOrdersScreenState
    extends State<DealerAcceptedOrdersScreen> {
  late Future<List<Map<String, dynamic>>> acceptedOrders;

  @override
  void initState() {
    super.initState();
    acceptedOrders =
        DealerAcceptedOrdersApi.getAcceptedOrders(widget.shopId);
  }

  void refreshPage()async{
    setState(() {
      acceptedOrders = DealerAcceptedOrdersApi.getAcceptedOrders(widget.shopId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,

        title: Text(
          "Accepted Pickups",
          style: AppTextStyle.bold18(color: AppColors.whiteColor),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.whiteColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: acceptedOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No accepted orders",
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
                  UpdateOrderStatusApi.update(int.parse(order["order_id"]), "COMPLETED");
                  refreshPage();
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

                      /// Status Badge
                      Row(
                        children: const [
                          Icon(Icons.timelapse,
                              size: 16, color: Colors.orange),
                          SizedBox(width: 6),
                          Text(
                            "Accepted",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
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
        },
      ),
    );
  }
}
