import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({this.title, this.color, this.onTapped});

  final String title;
  final Color color;
  final Function onTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(
            Radius.circular(25.0),
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 10,
              offset: Offset(0, 5),
            )
          ]),
      child: Center(
        child: GestureDetector(
          onTap: () {},
          child: Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: "Netflix",
              fontWeight: FontWeight.w600,
              fontSize: 18,
              letterSpacing: 0.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  //   Padding(
  //     padding: const EdgeInsets.all(10.0),
  //     child: InkWell(
  //       onTap: onTapped,
  //       child: Container(
  //         height: 40.0,
  //         width: 200.0,
  //         color: color,
  //         child: Center(
  //           child: Text(
  //             title,
  //             style: TextStyle(fontSize: 20.0, color: Colors.white),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
