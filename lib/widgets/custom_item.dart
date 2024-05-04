import 'package:flutter/material.dart';

class CustomItem extends StatelessWidget {
  final String defaultAssetImagePath = 'assets/images/default.png';
  String imageUrl = '';
  String name = '';
  int price = 0;
  int count = 0;
  VoidCallback onTapped, onAddTapped;
  Size size;

  CustomItem({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.size,
    required this.count,
    required this.onTapped,
    required this.onAddTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: Colors.blueGrey,
            ),
          ),
          child: InkWell(
            onTap: onTapped,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: FadeInImage(
                    placeholder: AssetImage(defaultAssetImagePath),
                    image: NetworkImage(imageUrl),
                    width: size.width < size.height
                        ? size.width * 0.5 - 20
                        : size.width * 0.25,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text('    $name'),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('  $count#'),
                    const Spacer(),
                    Text(
                      '$price\$    ',
                      style: TextStyle(color: Colors.blueGrey.shade600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          child: InkWell(
            onTap: onAddTapped,
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.blueGrey,
              ),
              child: const Center(
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
