import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/brand_card.dart';
import 'package:shop/components/group_row.dart';
import 'package:shop/models/items/item.dart';
import 'package:shop/repositories/images.dart';
import 'package:shop/screens/details.dart';
import 'package:shop/state/brands_store.dart';
import 'package:shop/state/cart_store.dart';
import 'package:shop/state/store_state.dart';

class Brand extends StatefulWidget {
  final String brand;

  Brand({required this.brand});

  @override
  _BrandState createState() => _BrandState();
}

class _BrandState extends State<Brand> {
  BrandsStore? _brandStore;
  CartStore? _cartStore;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _brandStore ??= Provider.of<BrandsStore>(context);
    _cartStore ??= Provider.of<CartStore>(context);

    _brandStore!.getBrandData();

    super.didChangeDependencies();
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
        switch (_brandStore!.state) {
          case StoreState.loading:
          case StoreState.initial:
            return _buildLoader();
          default:
            return Column(children: [
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width / 2,
                child: BrandCard(
                  margin: const EdgeInsets.symmetric(vertical: 14.0),
                  image: ImageRepository.getLogo(brand: widget.brand),
                  showBorder: false,
                  width: 75,
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 10,
                ),
                child: Text(
                  _brandStore!.description,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Divider(),
              GroupRow(
                title: "Featured Products",
                items: _brandStore!.featuredItems,
                onTap: (item) async {
                  _showDetailsScreen(context: context, item: item);
                },
              ),
              GroupRow(
                title: "Popular",
                items: _brandStore!.popularItems,
                onTap: (item) async {
                  _showDetailsScreen(context: context, item: item);
                },
              ),
              GroupRow(
                title: "New Arrivals",
                items: _brandStore!.newArrivals,
                onTap: (item) async {
                  _showDetailsScreen(context: context, item: item);
                },
              ),
            ]);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 24,
        title: Text(
          "Shop",
          style: TextStyle(
            fontSize: 30,
            fontFamily: "Futura",
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(child: _buildGroup()),
    );
  }
}
