import 'package:flutter/material.dart';
import 'package:food_order/constants/payment_qr.dart';
import 'package:food_order/components/main_button.dart';
import 'package:food_order/pages/delivery_page.dart';
import 'package:food_order/utils/currency_formatter.dart';

class PaymentPage extends StatefulWidget {
  final double total;
  const PaymentPage({super.key, required this.total});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final String _orderCode;

  @override
  void initState() {
    super.initState();
    final String millis = DateTime.now().millisecondsSinceEpoch.toString();
    _orderCode = millis.substring(millis.length - 6);
  }

  void pay() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Xác nhận đã chuyển khoản",
          style: TextStyle(fontSize: 18),
        ),
        content: const Text(
          "Bạn đã quét mã QR và hoàn tất thanh toán chưa?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DeliveryPage(),
              ),
            ),
            child: const Text(
              "Đã thanh toán",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int amount = widget.total.round();
    final String qrImageUrl = PaymentQr.buildQrImageUrl(
      amount: amount,
      orderCode: _orderCode,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Thanh toán"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  width: 320,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Quét mã QR để thanh toán',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: PaymentQr.isConfigured
                            ? Image.network(
                                qrImageUrl,
                                width: 240,
                                height: 240,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 240,
                                    height: 240,
                                    color: Colors.grey.shade300,
                                    alignment: Alignment.center,
                                    child: const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Text(
                                        'Không tải được mã QR.\nVui lòng kiểm tra thông tin bankId, accountNo trong constants/payment_qr.dart',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                width: 240,
                                height: 240,
                                color: Colors.grey.shade300,
                                alignment: Alignment.center,
                                child: const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text(
                                    'Vui lòng cấu hình bankId và accountNo trong constants/payment_qr.dart',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Số tiền QR: ${formatVnd(amount)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Mã đơn: $_orderCode'),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Tổng: ${formatVnd(widget.total)}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  MainButton(
                    onTap: () {
                      pay();
                    },
                    text: "Tôi đã chuyển khoản",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
