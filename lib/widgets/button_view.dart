import 'package:flutter/material.dart';
import 'package:social_media/resources/dimens.dart';

class ButtonView extends StatelessWidget {
  final String text;
  final Function onTap;

  const ButtonView({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: double.infinity,
        height: MARGIN_XXLARGE,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(
            MARGIN_LARGE,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: TEXT_REGULAR_2X,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
