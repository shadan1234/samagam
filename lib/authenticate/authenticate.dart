
import 'package:flutter/cupertino.dart';
import 'package:samagam_hack/authenticate/register.dart';
import 'package:samagam_hack/authenticate/sign_in.dart';


class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn=true;
  void toggleView(){
    setState(() {
      showSignIn=!showSignIn;
    });

  }
  @override
  Widget build(BuildContext context) {
    if(showSignIn)
    return SignIn_Page(toggleView: toggleView);
    else
      return Register_Page(toggleView: toggleView);
  }
}
