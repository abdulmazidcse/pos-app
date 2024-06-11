import 'package:flutter/material.dart';

class HelplineBox extends StatelessWidget {
  final Color bgColorTop;
  final Color bgColorBttm;
  final Color bgColor;
  final IconData icon;
  final String text;
  final String subtext;

  const HelplineBox({
    required this.bgColorTop,
    required this.bgColorBttm,
    required this.bgColor,
    required this.icon,
    required this.text,
    required this.subtext,
  });

  @override
  Widget build(BuildContext context) {
    // child: Card(
    return Expanded(
      // child: Container(
      //   decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //       begin: Alignment.bottomCenter,
      //       end: Alignment.topCenter,
      //       colors: [
      //         Color(0xFF9CCC3C).withOpacity(0.90),
      //         Color(0xFF25B771),
      //       ],
      //     ),
      //   ),
      //   child: Text('Your content here'),
      // ),
      child: Container(
        // transform: Matrix4.skewY(-0.05),
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        width: 90.0,
        height: 110.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            // borderRadius: const BorderRadius.only(
            //   topLeft: Radius.circular(12.0), // Adjust the radius as needed
            //   topRight: Radius.circular(12.0), // Adjust the radius as needed
            //   bottomLeft: Radius.circular(12.0),
            //   bottomRight: Radius.circular(12.0),
            // ),
            // gradient: LinearGradient(
            //   begin: Alignment.bottomLeft,
            //   end: Alignment.topRight,
            //   colors: [
            //     bgColor.withOpacity(0.90),
            //     bgColor,
            //   ],
            // ),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                bgColorTop,
                bgColorBttm, // Color(0xFF25B771),
                // Color(0xFF9CCC3C),
              ],
            )),
        child: Stack(
          children: [
            Positioned(
              top: 5.0,
              left: 5.0,
              right: 5.0,
              bottom: 5.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                  // borderRadius: const BorderRadius.only(
                  //   topLeft: Radius.circular(12.0),
                  //   topRight: Radius.circular(12.0),
                  //   bottomLeft: Radius.circular(12.0),
                  //   bottomRight: Radius.circular(12.0),
                  // ),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.1),
                  //     spreadRadius: 0,
                  //     blurRadius: 18,
                  //     offset: Offset(0, 3),
                  //   ),
                  // ],
                ),
                // transform: Matrix4.skewX(-0.10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: bgColor.withOpacity(0.2),
                              child: Icon(icon, color: bgColor, size: 25),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              text,
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              subtext,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
