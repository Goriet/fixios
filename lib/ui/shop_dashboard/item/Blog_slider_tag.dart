import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/constant/ps_dimens.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_ui_widget.dart';
import 'package:fluttermultistoreflutter/viewobject/shop_tag.dart';
import 'package:flutter/material.dart';

class BlogSliderTagView extends StatefulWidget {
  const BlogSliderTagView({
    Key key,
    @required this.subShopTagList,
    this.onTap,
  }) : super(key: key);

  final Function onTap;
  final List<ShopTag> subShopTagList;

  @override
  _BlogSliderState createState() => _BlogSliderState();
}

class _BlogSliderState extends State<BlogSliderTagView> {
  String _currentId;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (widget.subShopTagList != null && widget.subShopTagList.isNotEmpty)
          CarouselSlider(
            options: CarouselOptions(
              enlargeCenterPage: true,
              autoPlay: false,
              viewportFraction: 0.9,
              autoPlayInterval: const Duration(seconds: 5),
              onPageChanged: (int i, CarouselPageChangedReason reason) {
                setState(() {
                  _currentId = widget.subShopTagList[i].id;
                });
              },
            ),
            items: widget.subShopTagList.map((ShopTag tagProduct) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: PsColors.mainLightShadowColor,
                  ),
                  borderRadius:
                      const BorderRadius.all(Radius.circular(PsDimens.space8)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: PsColors.mainLightShadowColor,
                        offset: const Offset(1.1, 1.1),
                        blurRadius: PsDimens.space8),
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(PsDimens.space4),
                      child: PsNetworkImage(
                          photoKey: '',
                          defaultPhoto: tagProduct.defaultPhoto,
                          width: MediaQuery.of(context).size.width,
                          height: PsDimens.space300,
                          onTap: () {
                            widget.onTap(tagProduct);
                          }),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () {
                          widget.onTap(tagProduct);
                        },
                        child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: PsColors.black.withAlpha(200)),
                          padding: const EdgeInsets.only(
                              top: PsDimens.space8,
                              left: PsDimens.space8,
                              right: PsDimens.space8,
                              bottom: PsDimens.space20),
                          child: Ink(
                            color: PsColors.backgroundColor,
                            child: Text(
                              tagProduct.name,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                      fontSize: PsDimens.space16,
                                      color: PsColors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          )
        else
          Container(),

        // ),
        Positioned(
            bottom: 10.0,
            left: 0.0,
            right: 0.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.subShopTagList != null &&
                      widget.subShopTagList.isNotEmpty
                  ? widget.subShopTagList.map((ShopTag tagProduct) {
                      return Builder(builder: (BuildContext context) {
                        return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentId == tagProduct.id
                                    ? PsColors.mainColor
                                    : PsColors.grey));
                      });
                    }).toList()
                  : <Widget>[Container()],
            ))
      ],
    );
  }
}
