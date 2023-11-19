import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/badge_counter.dart';
import 'package:shop/repositories/item_repository.dart';
import 'package:shop/screens/cart.dart';
import 'package:shop/screens/home.dart';
import 'package:shop/screens/settings.dart';
import 'package:shop/state/cart_store.dart';
import 'package:shop/state/home_store.dart';
import 'package:shop/utilities/colors.dart';
import 'package:shop/utilities/config.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();

    themeNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      title: 'Hype',
      theme: ThemeData.light().copyWith(
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.ebony,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Colors.black,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          // backgroundColor: AppColors.navBlack,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black45,
          showUnselectedLabels: true,
        ),
        primaryColor: AppColors.marinerBlue,
        textTheme: ThemeData.light().textTheme.copyWith(),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(primary: Colors.black),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(primary: Colors.black),
        ),
        backgroundColor: Colors.white,
        canvasColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            primary: Colors.black,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          color: AppColors.deepBlack,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(primary: Colors.white),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(primary: Colors.white),
        ),
        primaryColor: AppColors.deepBlack,
        backgroundColor: AppColors.deepBlack,
        canvasColor: AppColors.bunkerBlack,
        scaffoldBackgroundColor: AppColors.deepBlack,
      ),
      home: MultiProvider(
        providers: [
          Provider<HomeStore>(
              create: (_) => HomeStore(itemRepository: ItemRepository())),
          Provider<CartStore>(create: (_) => CartStore()),
        ],
        child: Main(title: 'Home'),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Main extends StatefulWidget {
  Main({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _selectedIndex = 0;
  CartStore? _cartStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartStore ??= Provider.of<CartStore>(context);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _tabItem({
    required text,
    required iconData,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(iconData),
      label: text,
    );
  }

  _tabItemWithCounter({
    required text,
    required iconData,
  }) {
    return BottomNavigationBarItem(
      label: text,
      icon: Stack(
        children: <Widget>[
          Icon(iconData),
          Positioned(
            right: 0,
            child: Observer(
              builder: (_) {
                return BadgeCounter(data: _cartStore!.items.length);
              },
            ),
          )
        ],
      ),
    );
  }

  _navigation() {
    final theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(
        // Turn off ink on tap
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.white,
          border: Border(
            top: BorderSide(
              // turn this on with light theme?
              color: theme.dividerColor,
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          // backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 30,
          items: [
            _tabItem(text: "Home", iconData: CupertinoIcons.house_alt),
            _tabItemWithCounter(
              text: "Cart",
              iconData: CupertinoIcons.shopping_cart,
            ),
            _tabItem(text: "Settings", iconData: CupertinoIcons.person),
          ],
        ),
      ),
    );
  }

  Widget _screen(int index) {
    switch (index) {
      case 0:
        return Home();
      case 1:
        return Cart(isModal: false);
      case 2:
        return Settings();
      default:
        return Home();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _screen(_selectedIndex),
      ),
      bottomNavigationBar: _navigation(),
    );
  }
}
