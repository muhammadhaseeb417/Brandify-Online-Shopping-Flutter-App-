import 'package:brand_shoes/consts.dart';
import 'package:brand_shoes/pages/signup.dart';
import 'package:brand_shoes/servics/auth_service.dart';
import 'package:brand_shoes/widgets/navigation_widget.dart';
import 'package:brand_shoes/widgets/signUp_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<StatefulWidget> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String? email, password;
  final GlobalKey<FormState> _formkey = GlobalKey();
  final SelectedImageController selectedImageController =
      Get.put(SelectedImageController());

  final GetIt getIt = GetIt.instance;

  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = getIt.get<AuthService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _backgroundHeader(context),
          SingleChildScrollView(
            child: Column(
              children: [
                _HeaderText(context),
                _SubHeaderText(context),
                _SignInForm(context),
                _SignUpPrompt(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _backgroundHeader(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary, // Light Blue
            Colors.red, // Purple
          ],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.elliptical(MediaQuery.of(context).size.width, 120),
        ),
      ),
    );
  }

  Widget _HeaderText(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 100),
      child: Center(
        child: Text(
          "SignIn",
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _SubHeaderText(BuildContext context) {
    return Text(
      "Login to your account",
      style: TextStyle(
        fontSize: 17,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _SignInForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Material(
        elevation: 10.0,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.1,
          height: MediaQuery.of(context).size.height / 2,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const InputLabel(text: "Email"),
                  SignUpTextFIeld(
                    icon: Icon(Icons.mail_outline),
                    textFieldValidator: EMAIL_VALIDATION_REGEX,
                    hintText: "Email",
                    onSaved: (value) {
                      if (value != null) {
                        email = value;
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  const InputLabel(text: "Password"),
                  SignUpTextFIeld(
                    icon: Icon(Icons.password_outlined),
                    textFieldValidator: PASSWORD_VALIDATION_REGEX,
                    hintText: 'Password',
                    obsurceText: true,
                    onSaved: (value) {
                      if (value != null) {
                        password = value;
                      }
                    },
                  ),
                  _ForgotPasswordText(context),
                  _SignInButton(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _ForgotPasswordText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        alignment: Alignment.topRight,
        child: const Text(
          'Forget Password?',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _SignInButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              if (_formkey.currentState!.validate() ?? false) {
                _formkey.currentState!.save();
                bool result =
                    await _authService.checkUserLogin(email, password);
                print(result);
                if (result != null && result == true) {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return NavigationWidget();
                    },
                  ));
                  Get.find<NavigationController>().resetToHome();
                } else {}
              }
            } catch (e) {
              print(e);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            elevation: 10.0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            fixedSize: const Size(120, 50),
          ),
          child: const Text(
            'SignIn',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _SignUpPrompt(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Arial',
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUp();
                  },
                ),
              );
            },
            child: Text(
              'Sign up Now!',
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: 'Arial',
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InputLabel extends StatelessWidget {
  final String text;
  const InputLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
