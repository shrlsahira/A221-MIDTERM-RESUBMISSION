import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mainscreen/loginscreen.dart';
import 'package:mainscreen/mainscreen.dart';
import 'package:mainscreen/registrationscreen.dart';
import 'package:mainscreen/model/user.dart';
import 'package:mainscreen/sellerscreen.dart';


class MainMenuWidget extends StatefulWidget {
  final User user;
  const MainMenuWidget({super.key, required this.user});

  @override
  State<MainMenuWidget> createState() => _MainMenuWidgetState();
}

class _MainMenuWidgetState extends State<MainMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      elevation: 10,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(widget.user.email.toString()),
            accountName: Text(widget.user.name.toString()),
            currentAccountPicture: const CircleAvatar(
              radius: 30.0,
            ),
          ),
          ListTile(
            title: const Text('Buyer'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MainScreen(user: widget.user)));
            },
          ),
          ListTile(
            title: const Text('Seller'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => SellerScreen(user: widget.user)));
            },
          ),
          ListTile(
            title: const Text('Sign In'),
            onTap: () {
              if (widget.user.id == "0") {
                return _haveaccount();
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(
                              user: widget.user,
                            )));
                Fluttertoast.showToast(
                    msg: "Please log out your account first.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    fontSize: 14.0);
              }
            },
          ),
        ],
      ),
    );
  }

  void _haveaccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Sign In",
            style: TextStyle(),
          ),
          content: const Text("Do you have an account?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
                onPressed: _yesButton,
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                )),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => const RegistrationScreen()));
              },
            ),
          ],
        );
      },
    );
  }

  void _yesButton() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
    Fluttertoast.showToast(
        msg: "You may log in to your account here",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 14.0);
        }
}