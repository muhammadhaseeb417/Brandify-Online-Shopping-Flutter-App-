import 'package:brand_shoes/pages/edit_profile.dart';
import 'package:brand_shoes/pages/login.dart';
import 'package:brand_shoes/pages/signup.dart';
import 'package:brand_shoes/servics/auth_service.dart';
import 'package:brand_shoes/widgets/custom_textfield.dart';
import 'package:brand_shoes/widgets/same_containor.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../consts.dart';
import '../servics/database_services.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late DatabaseServices _databaseServices;

  Map<dynamic, dynamic>? _currentUserData;
  bool _isLoading = true;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _databaseServices = _getIt.get<DatabaseServices>();
    userEmail = _authService.user?.email;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      _currentUserData =
          await _databaseServices.getDocuemntData(uid: _authService.user!.uid);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Setting',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent, // Makes the AppBar transparent
        elevation: 0, // Removes AppBar shadow
      ),
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.25,
          width: MediaQuery.sizeOf(context).width,
          color: Theme.of(context).colorScheme.primary,
          child: Container(
            margin:
                EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.11),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _topHeaderProfile(context),
              ],
            ),
          ),
        ),
        _remainingSetting(context),
      ],
    );
  }

  Widget _topHeaderProfile(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width * 0.04,
      ),
      child: Column(
        children: [
          _settingHeader(context),
        ],
      ),
    );
  }

  Widget _settingHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.09,
                width: MediaQuery.sizeOf(context).height * 0.09,
                child: ClipOval(
                  child: Image.network(
                    _currentUserData?["pfpURL"] ?? PLACEHOLDER_PFP,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.02,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userEmail ?? "Don't have a account",
                    style: TextStyle(
                      color: Colors.white60,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    _currentUserData?["name"] ?? "Register your account now",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              if (_authService.user == null) {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return SignUp();
                  },
                ));
              } else {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return EditProfile();
                  },
                ));
              }
            },
            child: Container(
              height: MediaQuery.sizeOf(context).height * 0.04,
              width: MediaQuery.sizeOf(context).width * 0.08,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(60),
              ),
              child: _authService.user == null
                  ? Icon(
                      Icons.person,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _remainingSetting(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (_authService.user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return EditProfile();
                    },
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignIn();
                    },
                  ),
                );
              }
            },
            child: _authService.user != null
                ? SettingContainor(conainorText: "Edit Profile")
                : SettingContainor(conainorText: "Login Now"),
          ),
          SettingContainor(conainorText: "Messages"),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.01,
          ),
          _authService.user != null
              ? Column(
                  children: [
                    SettingContainor(conainorText: "Change Password"),
                    SettingContainor(conainorText: "Forget Password"),
                  ],
                )
              : SizedBox.shrink(),
          SettingContainor(conainorText: "Support"),
          SettingContainor(conainorText: "Complient"),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.01,
          ),
          GestureDetector(
            onTap: () async {
              try {
                bool result = await _authService.SignOut();
                if (result != null && result == true) {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return SignIn();
                    },
                  ));
                } else {}
              } catch (e) {
                print(e);
              }
            },
            child: _authService.user != null
                ? SettingContainor(
                    conainorText: "Sign Out",
                    textColor: Colors.red,
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _UserProfileForm(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 0.5,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            maxRadius: MediaQuery.sizeOf(context).width * 0.15,
            backgroundImage: const NetworkImage(
                "https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small_2x/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg"),
          ),
          CustomTextField(
            hintText: 'Name',
            prefixIcon: const Icon(Icons.person),
          ),
          CustomTextField(
            hintText: 'Email',
            prefixIcon: const Icon(Icons.email),
          ),
          CustomTextField(
            hintText: 'Password',
            prefixIcon: const Icon(Icons.password),
            obsureText: true,
          ),
        ],
      ),
    );
  }
}
