import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final Function() onTap;
  final bool acttive;

  ButtonWidget({
    required this.text,
    required this.onTap,
    required this.acttive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width / 3.5,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: acttive ? const Color(0xff5ED5AB) : const Color(0xff777777),
        boxShadow: [
          BoxShadow(
              color: acttive
                  ? const Color(0xff5ED5AB).withOpacity(0.15)
                  : Colors.transparent,
              offset: const Offset(0, 10),
              blurRadius: 20,
              spreadRadius: 0),
        ],
      ),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(
            color: acttive ? Colors.black : Colors.white54,
          ),
        ),
      ),
    );
  }
}
