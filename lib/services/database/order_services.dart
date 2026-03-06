import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');

  Future<void> saveOrderToDatabase(String receipt) async {
    try {
      await orders.add({
        'date': DateTime.now(),
        'order': receipt,
      });
    } on FirebaseException catch (e) {
      throw Exception(
        'Không thể lưu đơn hàng: ${e.message ?? e.code}',
      );
    } catch (_) {
      throw Exception('Đã xảy ra lỗi khi lưu đơn hàng. Vui lòng thử lại.');
    }
  }
}
