import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/brand_card.dart';
import 'package:shop/components/group_row.dart';
import 'package:shop/components/feature_card.dart';
import 'package:shop/models/items/item.dart';
import 'package:shop/repositories/images.dart';
import 'package:shop/repositories/item_repository.dart';
import 'package:shop/screens/brand.dart';
import 'package:shop/screens/details.dart';
import 'package:shop/screens/search.dart';
import 'package:shop/state/brands_store.dart';
import 'package:shop/state/cart_store.dart';
import 'package:shop/state/home_store.dart';
import 'package:shop/state/search_store.dart';
import 'package:shop/state/store_state.dart';
import 'package:shop/utilities/colors.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeStore? _homeStore;
  CartStore? _cartStore;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeStore ??= Provider.of<HomeStore>(context);
    _cartStore ??= Provider.of<CartStore>(context);

    _homeStore!.load();
  }

  void _showDetailsScreen({
    required BuildContext context,
    required Item item,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        builder: (BuildContext context) {
          return MultiProvider(
            providers: [Provider<CartStore>(create: (_) => _cartStore!)],
            child: Details(item: item),
          );
        },
      ),
    );
  }

  void _showBrandScreen({
    required BuildContext context,
    required String brand,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        builder: (BuildContext context) {
          return MultiProvider(
            providers: [
              Provider<BrandsStore>(
                create: (_) => BrandsStore(
                  brand: brand,
                  itemRepository: ItemRepository(),
                ),
              ),
              Provider<CartStore>(create: (_) => _cartStore!)
            ],
            child: Brand(brand: brand),
          );
        },
      ),
    );
  }

  Widget _buildLoader() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        height: 60,
        width: 60,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildGroup() {
    return Observer(
      builder: (_) {
        switch (_homeStore!.state) {
          case StoreState.loading:
          case StoreState.initial:
            return _buildLoader();
          default:
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 4.0),
                  child: _homeStore!.featuredItem != null
                      ? FeatureCard(
                          item: _homeStore!.featuredItem!,
                          logo: "assets/logos/nike_white.png",
                          onTap: () {
                            _showDetailsScreen(
                                context: context,
                                item: _homeStore!.featuredItem!);
                          },
                        )
                      : Container(),
                ),
                GroupRow(
                  title: "Popular",
                  items: _homeStore!.popularItems,
                  onTap: (item) async {
                    _showDetailsScreen(context: context, item: item);
                  },
                ),
                GroupRow(
                  title: "New Arrivals",
                  items: _homeStore!.newArrivals,
                  onTap: (item) async {
                    _showDetailsScreen(context: context, item: item);
                  },
                ),
                _buildBrandRow(),
              ],
            );
        }
      },
    );
  }

  Widget _buildBrandRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: 5,
          ),
          child: Text(
            "Shop by brand",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 80,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            children: [
              BrandCard(
                image: ImageRepository.nike,
                onTap: () {
                  _showBrandScreen(context: context, brand: "Nike");
                },
              ),
              BrandCard(
                image: ImageRepository.balenciaga,
                onTap: () {
                  _showBrandScreen(context: context, brand: "Balenciaga");
                },
              ),
              BrandCard(
                image: ImageRepository.adidas,
                onTap: () {
                  _showBrandScreen(context: context, brand: "Adidas");
                },
              ),
              // BrandCard(image: ImageRepository.offWhite),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          titleSpacing: 24,
          title: Text(
            "Hype",
            style: TextStyle(
              fontSize: 30,
              fontFamily: "Futura",
            ),
          ),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(CupertinoIcons.search),
              onPressed: () async {
                await Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (BuildContext context) {
                      return MultiProvider(
                        providers: [
                          Provider<SearchStore>(
                            create: (_) =>
                                SearchStore(itemRepository: ItemRepository()),
                          ),
                          Provider<CartStore>(create: (_) => _cartStore!)
                        ],
                        child: Search(),
                      );
                    },
                  ),
                );
              },
            )
          ],
          bottom: const TabBar(
            isScrollable: true,
            padding: EdgeInsets.only(bottom: 10),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 2.0,
                color: AppColors.mandyRed,
              ),
              insets: EdgeInsets.symmetric(horizontal: 16.0),
            ),
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            tabs: [
              Tab(text: "sneakers"),
              Tab(text: "popular"),
              Tab(text: "accessories"),
              Tab(text: "men"),
              Tab(text: "women"),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: _buildGroup(),
        ),
      ),
    );
  }
}
