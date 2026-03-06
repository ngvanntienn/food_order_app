import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_order/models/food.dart';
import 'package:http/http.dart' as http;

class FoodService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const Duration _requestTimeout = Duration(seconds: 8);

  static const List<Map<String, dynamic>> _vietnameseDishCatalog =
      <Map<String, dynamic>>[
    {
      'name': 'Chả cả lá vọng',
      'description':
          'Cá lăng tẩm nghệ thì là, ăn cùng bún, lạc rang và mắm tôm đặc trưng Hà Nội.',
      'price': 79000.0,
      'category': 'burgers',
      'imagePath':
          'https://owa.bestprice.vn/images/articles/uploads/top-15-mon-ngon-ha-noi-an-mot-lan-nho-ca-doi-6065871012dc7.jpg',
    },
    {
      'name': 'Phở cuốn',
      'description':
          'Bánh phở cuốn thịt bò xào rau thơm, chấm nước mắm chua ngọt thanh vị.',
      'price': 45000.0,
      'category': 'sides',
      'imagePath':
          'https://owa.bestprice.vn/images/articles/uploads/top-15-mon-ngon-ha-noi-an-mot-lan-nho-ca-doi-606588e1cbb63.jpg',
    },
    {
      'name': 'Bún thang',
      'description':
          'Bún nước trong ngọt thanh với gà xé, trứng, giò lụa và mắm tôm tạo hương đặc trưng.',
      'price': 55000.0,
      'category': 'burgers',
      'imagePath':
          'https://owa.bestprice.vn/images/articles/uploads/top-15-mon-ngon-ha-noi-an-mot-lan-nho-ca-doi-606586f703775.jpg',
    },
    {
      'name': 'Cháo sườn',
      'description':
          'Cháo gạo xay mịn nấu cùng sườn non, ăn kèm quẩy giòn và tiêu thơm.',
      'price': 35000.0,
      'category': 'burgers',
      'imagePath':
          'https://owa.bestprice.vn/images/articles/uploads/top-15-mon-ngon-ha-noi-an-mot-lan-nho-ca-doi-6065871012e7d.jpg',
    },
    {
      'name': 'Kem tràng tiền',
      'description':
          'Kem que mát lạnh nổi tiếng Hà Nội, vị cốm hoặc đậu xanh thơm ngậy.',
      'price': 20000.0,
      'category': 'desserts',
      'imagePath':
          'https://owa.bestprice.vn/images/articles/uploads/top-15-mon-ngon-ha-noi-an-mot-lan-nho-ca-doi-6065871012fe8.jpg',
    },
    {
      'name': 'Cốm làng Vòng',
      'description':
          'Cốm non dẻo thơm đặc sản mùa thu Hà Nội, thường dùng ăn vặt hoặc làm quà.',
      'price': 30000.0,
      'category': 'desserts',
      'imagePath':
          'https://owa.bestprice.vn/images/articles/uploads/top-15-mon-ngon-ha-noi-an-mot-lan-nho-ca-doi-6065871012f34.jpg',
    },
    {
      'name': 'Bánh tráng tỏi',
      'description':
          'Bánh tráng trộn tỏi phi thơm, vị mặn ngọt cay nhẹ, phù hợp món ăn vặt.',
      'price': 25000.0,
      'category': 'sides',
      'imagePath':
          'https://cdn.tgdd.vn/Files/2021/08/24/1377372/20-mon-an-vat-hot-nhat-hien-nay-ma-ban-khong-nen-bo-qua-du-chi-1-mon-202108240927074481.jpg',
    },
    {
      'name': 'Mực rim me',
      'description':
          'Mực khô rim sốt me chua ngọt cay nhẹ, đậm vị, thường dùng làm món nhắm.',
      'price': 65000.0,
      'category': 'sides',
      'imagePath':
          'https://cdn.tgdd.vn/Files/2021/08/24/1377372/20-mon-an-vat-hot-nhat-hien-nay-ma-ban-khong-nen-bo-qua-du-chi-1-mon-202108240925137375.jpg',
    },
    {
      'name': 'Chè thái',
      'description':
          'Chè mát lạnh với thạch, trái cây, mít và nước cốt dừa béo ngậy.',
      'price': 30000.0,
      'category': 'desserts',
      'imagePath':
          'https://file.hstatic.net/1000394081/file/nguon-goc-che-thai_cd721d16cb974ec295120294e51b448f.jpg',
    },
    {
      'name': 'Chè bắp nước cốt dừa',
      'description':
          'Chè bắp dẻo thơm nấu cùng nước cốt dừa, vị ngọt dịu và béo nhẹ.',
      'price': 28000.0,
      'category': 'desserts',
      'imagePath': 'https://cdn.tgdd.vn/2021/09/CookProduct/1-1200x676-11.jpg',
    },
  ];

  Future<List<Food>> fetchFoodMenu() async {
    try {
      final List<Food> firebaseFoods =
          await _fetchFoodFromFirebase().timeout(_requestTimeout);
      if (firebaseFoods.isNotEmpty) {
        return firebaseFoods;
      }
    } catch (_) {
      // Continue to connectivity check and local catalog fallback.
    }

    final bool hasInternet;
    try {
      hasInternet = await _hasInternetConnection();
    } catch (_) {
      throw Exception('Không thể kiểm tra kết nối mạng. Vui lòng thử lại.');
    }

    if (hasInternet) {
      return _buildCatalogFoods();
    }

    throw Exception('Không có kết nối mạng. Vui lòng thử lại.');
  }

  Future<List<Food>> _fetchFoodFromFirebase() async {
    try {
      final CollectionReference<Map<String, dynamic>> foodsRef =
          _firestore.collection('foods');

      final QuerySnapshot<Map<String, dynamic>> snapshot = await foodsRef.get();
      if (snapshot.docs.isEmpty) {
        await _seedCatalogToFirebase(foodsRef);

        final QuerySnapshot<Map<String, dynamic>> refetchedSnapshot =
            await foodsRef.get();
        if (refetchedSnapshot.docs.isEmpty) {
          return <Food>[];
        }

        return refetchedSnapshot.docs
            .map((doc) => Food.fromMap(doc.data()))
            .where((food) => food.name.trim().isNotEmpty)
            .toList();
      }

      return snapshot.docs
          .map((doc) => Food.fromMap(doc.data()))
          .where((food) => food.name.trim().isNotEmpty)
          .toList();
    } on FirebaseException catch (_) {
      throw Exception('Không thể tải dữ liệu món ăn từ Firebase.');
    } catch (_) {
      throw Exception('Đã xảy ra lỗi khi tải dữ liệu món ăn.');
    }
  }

  Future<void> _seedCatalogToFirebase(
    CollectionReference<Map<String, dynamic>> foodsRef,
  ) async {
    final WriteBatch batch = _firestore.batch();

    for (int i = 0; i < _vietnameseDishCatalog.take(10).length; i++) {
      final Map<String, dynamic> dish = _vietnameseDishCatalog[i];
      final DocumentReference<Map<String, dynamic>> docRef =
          foodsRef.doc('seed_${i + 1}');

      batch.set(
        docRef,
        <String, dynamic>{
          ...dish,
          'seedOrder': i + 1,
          'isSeeded': true,
          'createdAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    }

    await batch.commit();
  }

  List<Food> _buildCatalogFoods() {
    return _vietnameseDishCatalog
        .take(15)
        .map((dish) => Food.fromMap(dish))
        .where((food) => food.name.trim().isNotEmpty)
        .toList();
  }

  Future<bool> _hasInternetConnection() async {
    const List<String> probes = <String>[
      'https://www.gstatic.com/generate_204',
      'https://www.cloudflare.com/cdn-cgi/trace',
    ];

    for (final url in probes) {
      try {
        final response = await http
            .get(Uri.parse(url))
            .timeout(_requestTimeout, onTimeout: () => http.Response('', 408));

        if (response.statusCode >= 200 && response.statusCode < 400) {
          return true;
        }
      } catch (_) {
        // Try the next probe endpoint.
      }
    }

    return false;
  }
}
