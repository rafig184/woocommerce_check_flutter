import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final Color color;

  const CustomButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            )),
        onPressed: () {
          onTap();
        },
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ));
  }
}
