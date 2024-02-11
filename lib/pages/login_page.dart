import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/constants/app_constants.dart';
import 'package:flutter_chat_demo/constants/color_constants.dart';
import 'package:flutter_chat_demo/providers/auth_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';
import 'pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    switch (authProvider.status) {
      case Status.authenticateError:
        Fluttertoast.showToast(msg: "Sign in failed");
        break;
      case Status.authenticateCanceled:
        Fluttertoast.showToast(msg: "Sign in canceled");
        break;
      case Status.authenticated:
        Fluttertoast.showToast(msg: "Sign in success");
        break;
      default:
        break;
    }
    return Scaffold(
      appBar: AppBar(

      ),

      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Flashchat App',
                  style: TextStyle(
                    fontSize: 30,

                    fontWeight: FontWeight.bold,
                    color: ColorConstants.primaryColor,
                  ),
                ),
                SizedBox(height: 20),
                Image.asset(
                  'images/logo.png', // Replace with your image path
                  width: 110, // Adjust as needed
                  height: 200, // Adjust as needed
                ),
                TextButton.icon(
                  onPressed: () async {
                    authProvider.handleSignIn().then((isSuccess) {
                      if (isSuccess) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      }
                    }).catchError((error, stackTrace) {
                      Fluttertoast.showToast(msg: error.toString());
                      authProvider.handleException();
                    });
                  },
                  icon: Image.asset(
                    'images/1.png', // Assuming this is the path to your Google logo
                    width: 20, // Adjust as needed
                    height: 20, // Adjust as needed
                  ),
                  label: Text(
                    'Sign in with Google',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) return Color(0xffdd4b39).withOpacity(0.8);
                        return Color(0xffdd4b39);
                      },
                    ),
                    splashFactory: NoSplash.splashFactory,
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.fromLTRB(30, 15, 30, 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Loading
          Positioned(
            child: authProvider.status == Status.authenticating ? LoadingView() : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
