import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/search_text_field.dart';
import 'package:shop/models/items/item.dart';
import 'package:shop/screens/details.dart';
import 'package:shop/state/cart_store.dart';
import 'package:shop/state/search_store.dart';
import 'package:shop/state/store_state.dart';

class Search extends StatefulWidget {
  Search();

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  SearchStore? _searchStore;
  CartStore? _cartStore;

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _searchStore ??= Provider.of<SearchStore>(context);
    _cartStore ??= Provider.of<CartStore>(context);

    _searchStore!.search();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SearchTextField(
              controller: _textEditingController,
              onChanged: (String value) {
                _searchStore!.search(query: value);
              },
              onClear: () {
                _textEditingController.clear();
                _searchStore!.search();
              },
            ),
            Observer(
              builder: (_) {
                if (_searchStore!.state != StoreState.loaded) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  shrinkWrap: true,
                  itemCount: _searchStore!.results.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = _searchStore!.results[index];
                    return ListTile(
                      dense: true,
                      title: Text(
                        item.name,
                        style: TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(
                        item.brand,
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Icon(
                        CupertinoIcons.right_chevron,
                        size: 20,
                      ),
                      onTap: () {
                        _showDetailsScreen(context: context, item: item);
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
