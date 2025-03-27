import 'dart:async';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:multi_vendor/controllers/index_controller.dart';
import 'package:multi_vendor/controllers/msetting_controller.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/categorie_model.dart';
import 'package:multi_vendor/models/fornisseur_model.dart';
import 'package:multi_vendor/models/product_model.dart';
import 'package:multi_vendor/models/slider_model.dart';
import 'package:multi_vendor/services/check_update.dart';
import 'package:multi_vendor/services/fornisseur_service.dart';
import 'package:multi_vendor/services/product_service.dart';
import 'package:multi_vendor/services/slider_services.dart';
import 'package:multi_vendor/widgets/categorie_item.dart';
import 'package:multi_vendor/widgets/fornisseur_item.dart';
import 'package:multi_vendor/widgets/product_item.dart';
import 'package:multi_vendor/widgets/slider_item.dart';
import 'package:should_rebuild/should_rebuild.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../services/categorie_services.dart';
import '../search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreen> {
  final _controller = ScrollController();

  int _page_get = 1;
  late SliverGrid products;

  ValueNotifier<bool> showSlider = ValueNotifier(true);
  ValueNotifier<bool> showCategories = ValueNotifier(true);
  ValueNotifier<bool> showFornisseurs = ValueNotifier(true);

  List<Product> _listproducts = [];

  bool _loading = false;
  bool _visible = true, _dismis = false;

  @override
  void initState() {
    super.initState();
   
    _controller.addListener(() async {
      if (_controller.position.pixels >=
              _controller.position.maxScrollExtent - 150 &&
          !_loading) {
        _loading = true;
        Products();
        print("retry - call api from controller");
      }
    });

    CheckUpdate().checkUpdate();
  }

  bool from_setState = true;


  @override
  Widget build(BuildContext context) {
    return GetBuilder<MSettingController>(
        
        initState: (state) {
           products = ProductsLoading();
           Products();

        },
        didUpdateWidget: (oldWidget, state) {
         
           
          

        },
        tag: "setting",
        builder: (setting) {
          if(setting.change){
            _listproducts = [];
            _page_get = 1;
            products = ProductsLoading();
            Products();
            }

           setting.change = false;
           
          return CustomScrollView(
            controller: _controller,
            slivers: [
              SliderBuilder(),
              setting.isGrossist
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8),
                        child: Text(
                          "Fornisseurs".tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    )
                  : const SliverToBoxAdapter(),
              setting.isGrossist
                  ? FornisseursBuilder()
                  : const SliverToBoxAdapter(),
              Search(),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                  child: Text(
                    "Categories".tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              CategoriesBuilder(),
              products,
              SliverToBoxAdapter(
                  child: Visibility(
                visible: _visible,
                child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.sizeOf(context).width * 0.43),
                    height: MediaQuery.sizeOf(context).width * 0.13,
                    width: 60,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        color: MAIN_COLOR,
                      ),
                    )),
              ))
            ],
          );
        });
  }

  SliverToBoxAdapter SliderBuilder() {
    return SliverToBoxAdapter(
      key: const ValueKey(2),
      child: ShouldRebuild(
        shouldRebuild: (oldWidget, newWidget) => false,
        child: ValueListenableBuilder(
          valueListenable: showSlider,
          builder: (context, value, child) {
            print("value in build : $value");
            return AnimatedContainer(
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              height: value ? MediaQuery.sizeOf(context).height * .25 : 0,
              duration: const Duration(milliseconds: 400),
              child: FutureBuilder<List<SliderModel>>(
                key: const ValueKey(3),
                future: SliderServices().getSliders(),
                builder: (context, snapshot) {
                  print("value : $value");
                  if (value) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      print("sliders size = ${snapshot.data!.length}");
                      if (snapshot.hasData) {
                        if (snapshot.data!.isEmpty) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            showSlider.value = false;
                          });
                          return const SizedBox();
                        }

                        return CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            viewportFraction: 1,
                            initialPage: 0,
                          ),
                          items: snapshot.data!
                              .map((slider) => SliderItem(slider: slider))
                              .toList(),
                        );
                      } else if (snapshot.hasError) {
                        // Schedule the state change after the current frame

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          showSlider.value = false;
                        });

                        print("Error fetching data");
                        return const SizedBox();
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      print("waitting");
                      return Skeletonizer(
                        child: Skeleton.leaf(
                          enabled: true,
                          child: Container(
                            height: 100,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      );
                    }
                  }
                  return const SizedBox();
                },
              ),
            );
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter CategoriesBuilder() {
    return SliverToBoxAdapter(
      child: ShouldRebuild(
        shouldRebuild: (oldWidget, newWidget) => false,
        child: ValueListenableBuilder(
          valueListenable: showCategories,
          builder: (context, value, child) {
            print("value in build : $value");
            return Container(
              constraints: BoxConstraints(maxHeight: value ? 120 : 0),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: FutureBuilder<List<Category>>(
                key: const ValueKey(4),
                future: CategorieServices().getCategorie(),
                builder: (context, snapshot) {
                  print("value : $value");
                  if (value) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isEmpty) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            showCategories.value = false;
                          });
                          return const SizedBox();
                        }
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, position) =>
                              CategorieItem(category: snapshot.data![position]),
                        );
                      } else if (snapshot.hasError) {
                        // Schedule the state change after the current frame

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          showCategories.value = false;
                        });

                        print("Error fetching data");
                        return const SizedBox();
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      print("waitting");
                      return IgnorePointer(
                        ignoring: true,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(
                            5,
                            (index) =>
                                CategorieItem(category: Category.empty()),
                          ),
                        ),
                      );
                    }
                  }
                  return const SizedBox();
                },
              ),
            );
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter FornisseursBuilder() {
    return SliverToBoxAdapter(
      child: ShouldRebuild(
        shouldRebuild: (oldWidget, newWidget) => false,
        child: ValueListenableBuilder(
          valueListenable: showFornisseurs,
          builder: (context, value, child) {
            print("value in build : $value");
            return Container(
              constraints: BoxConstraints(maxHeight: value ? 120 : 0),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: FutureBuilder<List<FornisseurModel>>(
                  future: FornisseurService().getFornisseur(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, position) {
                            return FornisseurItem(
                              fornisseur: snapshot.data![position],
                            );
                          });
                    } else if (snapshot.hasError) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showFornisseurs.value = false;
                      });
                    }

                    return IgnorePointer(
                      ignoring: true,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(
                          5,
                          (index) => CategorieItem(category: Category.empty()),
                        ),
                      ),
                    );
                  }),
            );
          },
        ),
      ),
    );
  }

  SliverGrid ProductsLoading() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: .58,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, position) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
            child: ProductItem(
              loading: true,
              product: Product.emptyProduct(),
            ),
          );
        },
        childCount: 4,
      ),
    );
  }

  SliverGrid ProductsGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        childAspectRatio: .53,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, position) {
          return Padding(
            key: UniqueKey(),
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: ProductItem(
              product: _listproducts[position],
            ),
          );
        },
        childCount: _listproducts.length,
      ),
    );
  }

  SliverToBoxAdapter Search() {
    return SliverToBoxAdapter(
        child: Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: TextField(
        readOnly: true,
        autofocus: false,
        onTap: () {
          Get.find<IndexController>(tag: "index").changeIndex(2);
        },
        selectionHeightStyle: BoxHeightStyle.tight,
        decoration: InputDecoration(
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(horizontal: 5),
            prefixIcon: const Icon(
              Icons.search,
              size: 18,
            ),
            hintText: "Search for a product".tr,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    ));
  }

  void Products() async {
    var l = await ProductService().getProducts(_page_get);

    _listproducts.addAll(l);
    _listproducts = _listproducts
        .fold<Map<int, Product>>({}, (map, obj) {
          map[obj.id] = obj;
          return map;
        })
        .values
        .toList();

    _loading = false;

    print("current page size : ${l.length}");
    print("current page grid: ${_listproducts.length}");

    // ✅ Check if the widget is still mounted before calling setState
    if (!mounted) return;

    setState(() {
      from_setState = true;
      products = ProductsGrid();
      if (l.isNotEmpty) {
        _page_get = _page_get + 1;
        _visible = true;
      } else {
        _visible = false;
      }
    });

    l = [];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
}
