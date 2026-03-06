import 'package:flutter/material.dart';
import 'package:food_order/components/main_button.dart';
import 'package:food_order/models/restaurant.dart';
import 'package:food_order/pages/home_page.dart';
import 'package:food_order/services/auth/auth_check.dart';
import 'package:food_order/services/database/order_services.dart';
import 'package:provider/provider.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  FirestoreService db = FirestoreService();

  @override
  void initState() {
    super.initState();
    String receipt = context.read<Restaurant>().displayCartReceipt();
    db.saveOrderToDatabase(receipt).catchError((error) {
      if (!mounted) {
        return;
      }
      final String message =
          error.toString().replaceFirst('Exception: ', '').trim();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message.isEmpty
                ? 'Không thể lưu đơn hàng. Vui lòng thử lại.'
                : message,
          ),
        ),
      );
    });
  }

  void _clearCartAndNavigateHome(BuildContext context) {
    context.read<Restaurant>().clearCart();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double containerHeight = deviceHeight / 2;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: containerHeight,
                    child: Column(
                      children: [
                        Image.asset('images/delivery.png'),
                        const Text(
                          "Cảm ơn bạn đã đặt hàng!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.green),
                        ),
                        const Text(
                          "Đơn hàng sẽ được giao trong 30 phút",
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: MainButton(
                onTap: () {
                  _clearCartAndNavigateHome(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AuthCheck()));
                },
                text: "Trang chủ",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
