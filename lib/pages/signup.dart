import 'dart:io';

import 'package:brand_shoes/consts.dart';
import 'package:brand_shoes/models/user_profile.dart';
import 'package:brand_shoes/pages/login.dart';
import 'package:brand_shoes/servics/auth_service.dart';
import 'package:brand_shoes/servics/database_services.dart';
import 'package:brand_shoes/servics/medai_service.dart';
import 'package:brand_shoes/servics/storage_servics.dart';
import 'package:brand_shoes/widgets/navigation_widget.dart';
import 'package:brand_shoes/widgets/signUp_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? name, email, password;

  final GlobalKey<FormState> _formkey = GlobalKey();

  final SelectedImageController selectedImageController =
      Get.put(SelectedImageController());

  final GetIt _getIt = GetIt.instance;

  late MediaService _medaiService;
  late AuthService _authService;
  late StorageServics _storageServics;
  late DatabaseServices _databaseServices;

  @override
  void initState() {
    super.initState();
    _medaiService = _getIt.get<MediaService>();
    _authService = _getIt.get<AuthService>();
    _storageServics = _getIt.get<StorageServics>();
    _databaseServices = _getIt.get<DatabaseServices>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    return Stack(
      children: [
        _signUpTopBar(context),
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).height * 0.1),
                child: Center(
                  child: Text(
                    "SignUp",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Text(
                "Create a new account",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey[400],
                ),
              ),
              _signUpform(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _signUpTopBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary, // Light Blue
            Colors.red // Purple
          ],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.elliptical(MediaQuery.of(context).size.width, 120),
        ),
      ),
    );
  }

  Widget _signUpform(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Material(
            elevation: 10.0,
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.1,
              height: MediaQuery.sizeOf(context).height * 0.7,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),

                        _pfpSelectImage(context),

                        // Camera Icon

                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "Name",
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SignUpTextFIeld(
                          icon: Icon(Icons.person_2_outlined),
                          textFieldValidator: NAME_VALIDATION_REGEX,
                          hintText: 'Name',
                          onSaved: (value) {
                            if (value != null) {
                              name = value;
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SignUpTextFIeld(
                          icon: Icon(Icons.mail_outline),
                          textFieldValidator: EMAIL_VALIDATION_REGEX,
                          hintText: 'Email',
                          onSaved: (value) {
                            if (value != null) {
                              email = value;
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "Password",
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SignUpTextFIeld(
                          icon: Icon(Icons.password_outlined),
                          obsurceText: true,
                          textFieldValidator: PASSWORD_VALIDATION_REGEX,
                          hintText: 'Password',
                          onSaved: (value) {
                            if (value != null) {
                              password = value;
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return SignIn();
                                    },
                                  ));
                                },
                                child: Text(
                                  'Login Now',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
            child: _signUpButton(context),
          ),
        ),
      ],
    );
  }

  Widget _pfpSelectImage(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () async {
          File? file = await _medaiService.getImageFromGallery();
          if (file != null) {
            selectedImageController.selectedImage.value =
                file; // Correct assignment
          }
        },
        child: Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.2,
                backgroundImage: selectedImageController.selectedImage.value !=
                        null
                    ? FileImage(selectedImageController.selectedImage.value!)
                    : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
              ),
              Positioned(
                right: MediaQuery.of(context).size.width * 0.0001,
                bottom: MediaQuery.of(context).size.height * 0.001,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: MediaQuery.of(context).size.width * 0.1,
                  child: Image.network(
                      "https://cdn-icons-png.flaticon.com/512/5904/5904483.png"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signUpButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_formkey.currentState?.validate() ?? false) {
          _formkey.currentState?.save();

          if (email != null && password != null) {
            bool result = await _authService.registerNewUser(
                email: email!, password: password!);

            if (result) {
              String? downloadURL;

              // Check if the user has selected an image
              if (selectedImageController.selectedImage.value != null) {
                downloadURL = await _storageServics.uploadUserPfp(
                  file: selectedImageController.selectedImage.value!,
                  uid: _authService.user?.uid ?? '',
                );
              }

              // Ensure _authService.user is not null before using it
              if (_authService.user != null) {
                await _databaseServices.createRegisterUserInDatabase(
                  userProfile: UserProfile(
                    uid: _authService.user!.uid,
                    name: name,
                    pfpURL: downloadURL ?? PLACEHOLDER_PFP,
                  ),
                );

                // Navigate to the NavigationWidget after successful signup
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return NavigationWidget();
                  }),
                );

                // Reset the navigation controller to the home page
                Get.find<NavigationController>().resetToHome();
              }
            } else {
              print("Unable to create user");
            }
          } else {
            print("Email or password is null");
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 10.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        fixedSize: const Size(100, 50),
      ),
      child: const Text(
        'SignUp',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class SelectedImageController extends GetxController {
  Rx<File?> selectedImage = Rx<File?>(null);
}
