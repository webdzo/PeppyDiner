import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/ui/widgets/text_widget.dart';

class RoundedBackButton extends StatelessWidget {
  final Function()? onTap;
  const RoundedBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10.0),
        bottomLeft: Radius.circular(10.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ??
              () {
                Navigator.pop(context);
              },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25.0),
                bottomLeft: Radius.circular(25.0),
              ),
              color: HexColor("#d4ac2c"),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                const TextWidget("Back")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
