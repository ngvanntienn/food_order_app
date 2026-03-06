import 'package:flutter/material.dart';
import 'package:food_order/models/restaurant.dart';
import 'package:provider/provider.dart';

class CurrentLocation extends StatelessWidget {
  CurrentLocation({super.key});

  final TextEditingController addressController = TextEditingController();

  void openLocationSearchBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Vị trí của bạn",
          style: TextStyle(fontSize: 18),
        ),
        content: TextField(
          controller: addressController,
          decoration: const InputDecoration(
              hintText: "Nhập địa chỉ", hintStyle: TextStyle(fontSize: 15)),
        ),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              String newAddress = addressController.text;
              context.read<Restaurant>().updateDeliveryAddress(newAddress);
            },
            child: const Text(
              "Lưu",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 10.0, right: 10, top: 15, bottom: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.asset(
              'images/avatar.jpg',
              height: 45,
              width: 45,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Giao đến,",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: () => openLocationSearchBox(context),
                  child: Row(
                    children: [
                      Expanded(
                        child: Consumer<Restaurant>(
                            builder: (context, restaurant, child) {
                          String displayAddress =
                              restaurant.deliveryAddress.isEmpty
                                  ? "Vị trí của bạn"
                                  : restaurant.deliveryAddress;
                          return Text(
                            displayAddress,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          );
                        }),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded)
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
