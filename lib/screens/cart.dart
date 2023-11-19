import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/circle_icon_button.dart';
import 'package:shop/components/pill_button.dart';
import 'package:shop/models/items/item.dart';
import 'package:shop/repositories/item_repository.dart';
import 'package:shop/state/cart_store.dart';
import 'package:shop/utilities/format.dart';

class Cart extends StatefulWidget {
  final bool isModal;

  Cart({this.isModal = true});

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  CartStore? _cartStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartStore ??= Provider.of<CartStore>(context);
  }

  Widget _buildList() {
    return Observer(builder: (_) {
      if (_cartStore!.items.isEmpty) {
        return Center(
          child: Text(
            "Your cart is empty",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _cartStore!.items.length,
        itemBuilder: (context, index) {
          final item = _cartStore!.items[index];

          return ItemTitle(
            item: item,
            onDelete: () {
              _cartStore!.removeFromCart(index: index);
            },
          );
        },
        separatorBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Divider(),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      child: ProgressHUD(
        child: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text(
                "Cart",
              ),
              elevation: 0,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: _buildList(),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.backgroundColor,
                      border: Border(
                        top: BorderSide(
                          color: theme.dividerColor,
                          width: 0.4,
                        ),
                      ),
                    ),
                    // height: 209,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Observer(
                      builder: (_) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            OrderInfo(
                              subTotal: _cartStore!.subTotal,
                              shipping: _cartStore!.shipping,
                              total: _cartStore!.total,
                            ),
                            PillButton(
                              enabled: _cartStore!.items.isNotEmpty,
                              label: "Checkout",
                              onPressed: () async {
                                final progress = ProgressHUD.of(context);
                                progress?.showWithText("Processing order...");

                                Future.delayed(Duration(seconds: 2), () {
                                  _cartStore!.checkout();
                                  progress?.dismiss();
                                  progress?.showWithText("Order completed!");

                                  Future.delayed(Duration(seconds: 1), () {
                                    _cartStore!.reset();
                                    progress?.dismiss();

                                    if (widget.isModal) {
                                      Navigator.pop(context);
                                    }
                                  });
                                });
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OrderInfo extends StatelessWidget {
  final double subTotal;
  final double shipping;
  final double total;

  const OrderInfo({
    required this.subTotal,
    required this.shipping,
    required this.total,
    Key? key,
  }) : super(key: key);

  final double _spacing = 10;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(bottom: 20),
      color: theme.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Divider(),
          Text(
            "Order Info",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
          Container(
            height: _spacing,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Subtotal",
                style: theme.textTheme.caption,
              ),
              Text(Format.currency.format(this.subTotal)),
            ],
          ),
          Container(
            height: _spacing,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Shipping Cost",
                style: theme.textTheme.caption,
              ),
              Text("+${Format.currency.format(this.shipping)}"),
            ],
          ),
          Container(
            height: _spacing,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total"),
              Text(
                Format.currency.format(this.total),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ItemTitle extends StatelessWidget {
  final Item item;
  final GestureTapCallback? onDelete;

  const ItemTitle({
    required this.item,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 70,
      child: Row(
        children: [
          Container(
            width: 100,
            padding: EdgeInsets.all(4),
            child: Image.asset(
              item.imagePath,
            ),
          ),
          Container(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Container(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      Format.currency.format(item.price),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    Container(width: 20),
                    Text(
                      "Size: ${item.size}",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(width: 12),
          CircleIconButton(
            onTap: onDelete,
          )
        ],
      ),
    );
  }
}

class ItemDescription extends StatelessWidget {
  final String description;

  const ItemDescription({
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        description,
        textAlign: TextAlign.justify,
      ),
    );
  }
}
