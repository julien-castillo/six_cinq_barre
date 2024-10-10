import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   "assets/images/prosecco.png",
              //   width: 200,
              //   height: 200,
              //   fit: BoxFit.contain,
              // ),
              // Image.asset(
              //   "assets/images/65barre_2.png",
              //   // width: 200,
              //   // height: 200,
              //   fit: BoxFit.contain,
              // ),
              SvgPicture.asset(
                "assets/images/65barre_conductor.svg",
                colorFilter:
                    const ColorFilter.mode(Colors.orange, BlendMode.srcIn),
              ),
              const Text(
                "Orchestre 6/5 barré",
                style: TextStyle(fontSize: 42, fontFamily: 'Poppins'),
              ),
              const Text(
                "Dirigé par Guillemette Daboval.",
                style: TextStyle(
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const Padding(padding: EdgeInsets.only(top: 5)),
            ],
          ),
        ));
  }
}
