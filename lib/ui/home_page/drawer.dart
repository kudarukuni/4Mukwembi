import 'package:flutter/material.dart';
import 'package:oms/pages/home.dart';
import 'package:oms/pages/login.dart';

class AppDrawer extends StatefulWidget {
  get ecnumber => null;
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.scaleDown,
            image: AssetImage('android/assets/person.png')),
      ),
      child: Stack(children: <Widget>[]),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
              icon: Icons.timelapse,
              text: 'Logout',
              onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage(
                                key: UniqueKey(),
                              )),
                    )
                  }),
        ],
      ),
    );
  }
}
