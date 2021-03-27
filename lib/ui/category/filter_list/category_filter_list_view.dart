import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttermultistoreflutter/api/common/ps_status.dart';
import 'package:fluttermultistoreflutter/config/ps_colors.dart';
import 'package:fluttermultistoreflutter/config/ps_config.dart';
import 'package:fluttermultistoreflutter/constant/ps_constants.dart';
import 'package:fluttermultistoreflutter/provider/category/category_provider.dart';
import 'package:fluttermultistoreflutter/repository/category_repository.dart';
import 'package:fluttermultistoreflutter/ui/common/base/ps_widget_with_appbar.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_frame_loading_widget.dart';
import 'package:fluttermultistoreflutter/ui/common/ps_ui_widget.dart';
import 'package:fluttermultistoreflutter/utils/utils.dart';
import 'package:fluttermultistoreflutter/viewobject/common/ps_value_holder.dart';
import 'package:fluttermultistoreflutter/viewobject/holder/category_parameter_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../item/category_search_list_item.dart';

class CategoryFilterListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CategoryFilterListViewState();
  }
}

class _CategoryFilterListViewState extends State<CategoryFilterListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  CategoryProvider _categoryProvider;
  final CategoryParameterHolder categoryIconList = CategoryParameterHolder();
  AnimationController animationController;
  Animation<double> animation;

  @override
  void dispose() {
    animationController.dispose();
    animation = null;
    super.dispose();
  }

  void onSubCategoryClick(Map<String, String> subCategory) {
    Navigator.pop(context, subCategory);
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _categoryProvider
            .nextCategoryList(_categoryProvider.latestCategoryParameterHolder);
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    animation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(animationController);
    super.initState();
  }

  CategoryRepository repo1;

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    repo1 = Provider.of<CategoryRepository>(context);

    print(
        '............................Build UI Again ............................');

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<CategoryProvider>(
          appBarTitle:
              Utils.getString(context, 'category_search_list__app_bar_name') ??
                  '',
          initProvider: () {
            return CategoryProvider(
                repo: repo1,
                psValueHolder: Provider.of<PsValueHolder>(context));
          },
          onProviderReady: (CategoryProvider provider) {
            provider.latestCategoryParameterHolder.shopId =
                provider.psValueHolder.shopId;
            provider.loadCategoryList(provider.latestCategoryParameterHolder);
            _categoryProvider = provider;
          },
          actions: <Widget>[
            IconButton(
              icon: Icon(MaterialCommunityIcons.filter_remove_outline,
                  color: PsColors.mainColor),
              onPressed: () {
                final Map<String, String> dataHolder = <String, String>{};
                dataHolder[PsConst.CATEGORY_ID] = '';
                dataHolder[PsConst.SUB_CATEGORY_ID] = '';
                onSubCategoryClick(dataHolder);
              },
            )
          ],
          builder:
              (BuildContext context, CategoryProvider provider, Widget child) {
            return Stack(children: <Widget>[
              Container(
                  child: RefreshIndicator(
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: provider.categoryList.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.categoryList.status ==
                          PsStatus.BLOCK_LOADING) {
                        return Shimmer.fromColors(
                            baseColor: PsColors.grey,
                            highlightColor: PsColors.white,
                            child: Column(children: const <Widget>[
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                            ]));
                      } else {
                        final int count = provider.categoryList.data.length;
                        animationController.forward();
                        return FadeTransition(
                            opacity: animation,
                            child: CategoryFilterListItem(
                              animationController: animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                              category: provider.categoryList.data[index],
                              onTap: () {
                                print(provider.categoryList.data[index]
                                    .defaultPhoto.imgPath);
                                Navigator.pop(
                                    context, provider.categoryList.data[index]);
                                print(provider.categoryList.data[index].name);
                              },
                            ));
                      }
                    }),
                onRefresh: () {
                  // provider.latestCategoryParameterHolder.shopId =
                  //     provider.psValueHolder.shopId;
                  return provider.resetCategoryList(
                      provider.latestCategoryParameterHolder);
                },
              )),
              PSProgressIndicator(provider.categoryList.status)
            ]);
          }),
    );
  }
}