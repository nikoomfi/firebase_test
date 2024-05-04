import 'package:flutter/material.dart';

class BasketBottom extends StatelessWidget {
  Size size;
  int totalPrice;
  VoidCallback onBuyPressed;

  BasketBottom({
    required this.totalPrice,
    required this.size,
    required this.onBuyPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        color: Colors.blueGrey,
      ),
      child: ListTile(
        title: Row(
          children: [
            const Text(
              'Total Price: ',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              '$totalPrice\$',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.white,
            ),
          ),
          onPressed: onBuyPressed,
          child: const Text(
            'Buy',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
