import 'package:flutter/material.dart';
import 'package:saf_user/resources/auth_methods.dart';
import 'package:saf_user/screens/signup_screen.dart';
import 'package:saf_user/utils/utility.dart';

import '../screens/login_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 0, 179, 255),
          ),
          child: Text(
            'Safeibala',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        ListTile(
          title: const Text('Sign Out'),
          onTap: () async {
            await AuthMethods().signOut();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignInScreen()));
            showSnackBar(context, 'See You Soon');
          },
        ),
        const Divider(),
      ],
    );
  }
}
