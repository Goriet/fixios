import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermultistoreflutter/viewobject/shipping_country.dart';

class CountryListItem extends StatelessWidget {
  const CountryListItem(
      {Key key,
      @required this.country,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final ShippingCountry country;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext contenxt, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 100 * (1.0 - animation.value), 0.0),
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: PsColors.backgroundColor,
                height: PsDimens.space52,
                margin: const EdgeInsets.only(top: PsDimens.space4),
                child: Padding(
                  padding: const EdgeInsets.all(PsDimens.space16),
                  child: Text(
                    country.name,
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
