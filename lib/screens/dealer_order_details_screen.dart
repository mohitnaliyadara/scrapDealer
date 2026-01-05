import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrapdealer/widgets/custom_button.dart';

import '../api_services/dealer_order_details_api.dart';
import '../api_services/update_order_status_api.dart';
import '../utils/app_colors.dart';
import '../utils/app_style.dart';

class DealerOrderDetailsScreen extends StatefulWidget {
  final int orderId;
  const DealerOrderDetailsScreen({super.key, required this.orderId});

  @override
  State<DealerOrderDetailsScreen> createState() =>
      _DealerOrderDetailsScreenState();
}

class _DealerOrderDetailsScreenState extends State<DealerOrderDetailsScreen> {
  late Future<Map<String, dynamic>> orderDetails;

  @override
  void initState() {
    super.initState();
    orderDetails = DealerOrderDetailsApi.getDetails(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "Order Details",
          style: AppTextStyle.bold18(color: AppColors.whiteColor),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.whiteColor),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: orderDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "Failed to load order",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final order = snapshot.data!["order"];
          final items = snapshot.data!["items"];

          return Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Order Info
                  Text(
                    "Order #${order["order_id"]}",
                    style: AppTextStyle.bold18(),
                  ),
                  const SizedBox(height: 4),
                  Text(order["pickup_address"]),
                  Text(
                    "Pickup: ${order["pickup_date"]} ${order["pickup_time"]}",
                    style: AppTextStyle.medium14(color: Colors.grey),
                  ),

                  const Divider(height: 24),

                  /// Scrap Items
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          title: Text(item["scrap_name"]),
                          subtitle: Text(
                            "₹${item["price"]} × ${item["weight"]} kg",
                          ),
                          trailing: Text(
                            "₹${item["total"]}",
                            style: AppTextStyle.bold16(),
                          ),
                        );
                      },
                    ),
                  ),

                  const Divider(),

                  /// Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Grand Total", style: AppTextStyle.bold16()),
                      Text(
                        "₹ ${order["grand_total"]}",
                        style: AppTextStyle.bold16(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// Buttons
                  Row(
                    children: [
                      Expanded(
                        child: customButton(
                          text: "Accept",
                          onPress: () async {
                            await UpdateOrderStatusApi.update(
                              widget.orderId,
                              "ACCEPTED",
                            );
                            Get.back();
                          },
                          textstyle: AppTextStyle.bold16(color: AppColors.whiteColor),
                          backcolor: AppColors.primaryColor,
                        ),
                      ),
SizedBox(width: 4,),
                      Expanded(
                        child: customButton(
                          text: "Complete",
                          onPress: () {
                            () async {
                              await UpdateOrderStatusApi.update(
                                widget.orderId,
                                "COMPLETED",
                              );
                              Get.back();
                            };
                          },
                          textstyle: AppTextStyle.bold16(color: AppColors.whiteColor),
                          backcolor: AppColors.primaryColor,

                        ),
                      ),
                    ],
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
