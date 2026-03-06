import 'package:flutter/material.dart';
import 'package:food_order/components/current_location.dart';
import 'package:food_order/components/food_tile.dart';
import 'package:food_order/components/nav_bar_menu_button.dart';
import 'package:food_order/constants/app_identity.dart';
import 'package:food_order/models/food.dart';
import 'package:food_order/models/restaurant.dart';
import 'package:food_order/pages/cart_page.dart';
import 'package:food_order/pages/food_page.dart';
import 'package:provider/provider.dart';
import '../components/app_drawer.dart';

enum MenuLoadState { loading, success, error }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Food> _menu = <Food>[];
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MenuLoadState _menuLoadState = MenuLoadState.loading;
  String _errorMessage = '';

  String _formatErrorMessage(Object error) {
    final String message =
        error.toString().replaceFirst('Exception: ', '').trim();
    if (message.isEmpty) {
      return 'Đã xảy ra lỗi khi tải dữ liệu.';
    }
    return message;
  }

  @override
  void initState() {
    super.initState();
    _initializeMenu();
  }

  Future<void> _initializeMenu() async {
    setState(() {
      _menuLoadState = MenuLoadState.loading;
      _errorMessage = '';
    });

    final restaurant = Provider.of<Restaurant>(context, listen: false);

    try {
      await restaurant.initializeMenu();
      if (!mounted) {
        return;
      }
      setState(() {
        _menu = restaurant.getFullMenu();
        _menuLoadState = MenuLoadState.success;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _menuLoadState = MenuLoadState.error;
        _errorMessage = _formatErrorMessage(e);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: NavBarMenuButton(scaffoldKey: _scaffoldKey),
        title: const Text(
          AppIdentity.appBarTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                Consumer<Restaurant>(
                  builder: (context, restaurant, child) {
                    int cartQuantity = restaurant.cart
                        .fold(0, (sum, item) => sum + item.quantity);
                    return Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.limeAccent, shape: BoxShape.circle),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CartPage()),
                              );
                            },
                            icon: const Icon(
                              Icons.shopping_cart,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        if (cartQuantity > 0)
                          Positioned(
                            right: 0,
                            top: -6,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                cartQuantity.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          CurrentLocation(),
          searchBar(),
          Expanded(child: _buildMenuSection()),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    switch (_menuLoadState) {
      case MenuLoadState.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case MenuLoadState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off_rounded, size: 44),
                const SizedBox(height: 12),
                const Text(
                  'Không thể tải dữ liệu. Vui lòng kiểm tra kết nối mạng.',
                  textAlign: TextAlign.center,
                ),
                if (_errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    _errorMessage,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _initializeMenu,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        );
      case MenuLoadState.success:
        return foodList();
    }
  }

  Container searchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 234, 234, 234),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        onChanged: (_) => setState(() {}),
        style: const TextStyle(color: Colors.black),
        controller: _searchController,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.search_sharp,
            color: Color.fromARGB(255, 102, 102, 102),
          ),
          hintText: "Tìm món ăn...",
          hintStyle: TextStyle(color: Colors.black),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget foodList() {
    final String keyword = _searchController.text.trim().toLowerCase();
    final List<Food> foods = _menu.where((food) {
      if (keyword.isEmpty) {
        return true;
      }

      final String name = food.name.toLowerCase();
      final String description = food.description.toLowerCase();
      return name.contains(keyword) || description.contains(keyword);
    }).toList();

    if (foods.isEmpty) {
      return const Center(
        child: Text('Không tìm thấy sản phẩm phù hợp.'),
      );
    }

    return ListView.builder(
      itemCount: foods.length,
      itemBuilder: (context, index) {
        return FoodTile(
          food: foods[index],
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FoodPage(food: foods[index]))),
        );
      },
    );
  }
}
