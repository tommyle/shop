import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shop/utilities/colors.dart';
import 'package:shop/utilities/config.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _hideAnnouncements = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        elevation: 0,
      ),
      body: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 12, bottom: 12),
        shrinkWrap: true,
        children: [
          ListTile(
            title: Text(
              "Hide announcements",
              // style: TextStyle(fontSize: 16),
            ),
            trailing: CupertinoSwitch(
              activeColor: AppColors.ebony,
              onChanged: (_) {
                setState(() {
                  _hideAnnouncements = !_hideAnnouncements;
                });
              },
              value: _hideAnnouncements,
            ),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Currency",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "USD",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            trailing: Icon(
              CupertinoIcons.right_chevron,
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text(
              "Dark Mode",
              style: TextStyle(fontSize: 16),
            ),
            trailing: CupertinoSwitch(
              activeColor: AppColors.ebony,
              onChanged: (_) {
                setState(() {
                  themeNotifier.switchTheme();
                });
              },
              value: themeNotifier.currentTheme() == ThemeMode.dark,
            ),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Account details",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            trailing: Icon(
              CupertinoIcons.right_chevron,
            ),
            onTap: () {},
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Payment methods",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            trailing: Icon(
              CupertinoIcons.right_chevron,
            ),
            onTap: () {},
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Devices",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            trailing: Icon(
              CupertinoIcons.right_chevron,
            ),
            onTap: () {},
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Two-factor authentication",
                  style: TextStyle(fontSize: 16),
                ),
                Icon(
                  CupertinoIcons.shield_fill,
                  color: Colors.green,
                )
              ],
            ),
            trailing: Icon(
              CupertinoIcons.right_chevron,
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
