import 'package:flutter/material.dart';

import 'package:food_order/models/food.dart';
import 'package:food_order/utils/currency_formatter.dart';

class FoodTile extends StatelessWidget {
  final Food food;
  final void Function()? onTap;

  const FoodTile({super.key, required this.food, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isNetworkImage = food.imagePath.startsWith('http://') ||
        food.imagePath.startsWith('https://');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: isNetworkImage
                      ? Image.network(
                          food.imagePath,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 80,
                              width: 80,
                              color: Colors.grey.shade300,
                              alignment: Alignment.center,
                              child: const Icon(Icons.broken_image_outlined),
                            );
                          },
                        )
                      : Image.asset(
                          food.imagePath,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      formatVnd(food.price),
                      style: TextStyle(
                          color: Colors.green.shade300,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      _shortenDescription(food.description),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      shape: BoxShape.circle),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                  ),
                )
              ],
            ),
          ),
        ),
        Divider(
          color: Colors.amber.shade300,
          indent: 25,
          endIndent: 25,
        )
      ],
    );
  }

  String _shortenDescription(String description, {int maxLength = 50}) {
    if (description.length <= maxLength) {
      return description;
    } else {
      return '${description.substring(0, maxLength)}...';
    }
  }
}
