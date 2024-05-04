import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30,
      left: 10,
      child: Container(
        height: 40,
        width: 40,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Material(
          color: Colors.blueGrey,
          shape: const CircleBorder(),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.only(left: 8),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
