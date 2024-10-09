import 'dart:io';

import 'package:brand_shoes/consts.dart';
import 'package:brand_shoes/models/user_profile.dart';
import 'package:brand_shoes/pages/signup.dart';
import 'package:brand_shoes/servics/auth_service.dart';
import 'package:brand_shoes/servics/database_services.dart';
import 'package:brand_shoes/servics/medai_service.dart';
import 'package:brand_shoes/servics/storage_servics.dart';
import 'package:brand_shoes/widgets/edit_profile_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Map<dynamic, dynamic>? _currentUserData;
  late DatabaseServices _databaseServices;
  late AuthService _authService;
  late StorageServics _storageServics;
  late MediaService _mediaService;
  final SelectedImageController selectedImageController =
      Get.put(SelectedImageController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _databaseServices = GetIt.instance.get<DatabaseServices>();
    _authService = GetIt.instance.get<AuthService>();
    _storageServics = GetIt.instance.get<StorageServics>();
    _mediaService = GetIt.instance.get<MediaService>();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      var userData =
          await _databaseServices.getDocuemntData(uid: _authService.user!.uid);

      nameController.text = userData?["name"] ?? "";
      emailController.text = _authService.user?.email ?? "";
      phoneController.text = userData?["phone"] ?? "";
      genderController.text = userData?["gender"] ?? "";

      // Handle the profile picture URL
      String? pfpURL = userData?["pfpURL"];

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

  Future<void> _updateUserProfile() async {
    try {
      String? downloadURL;

      // If a new image is selected, upload it to Firebase Storage
      if (selectedImageController.selectedImage.value != null) {
        downloadURL = await _storageServics.uploadUserPfp(
          file: selectedImageController.selectedImage.value!,
          uid: _authService.user!.uid,
        );
      }

      await _databaseServices.updateUserData(
        uid: _authService.user!.uid,
        data: {
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text.isNotEmpty
              ? phoneController.text
              : _currentUserData?["phone"],
          'gender': genderController.text.isNotEmpty
              ? genderController.text
              : _currentUserData?["gender"],
          'pfpURL':
              downloadURL ?? _currentUserData?["pfpURL"] ?? PLACEHOLDER_PFP,
        },
      );
      print("User profile updated successfully");
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: _appBar(context),
      body: _isLoading ? _loadingWidget() : _buildUI(context),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Edit Profile',
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin:
              EdgeInsets.only(right: MediaQuery.sizeOf(context).width * 0.03),
          child: GestureDetector(
            onTap:
                _updateUserProfile, // Call update function when "Save" is pressed
            child: const Text(
              "Save",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ],
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  Widget _loadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildUI(BuildContext context) {
    return Column(
      children: [
        _pfpSelectImage(context),
        _editProfileTextFields(context),
      ],
    );
  }

  Widget _pfpSelectImage(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () async {
          File? file = await _mediaService.getImageFromGallery();
          if (file != null) {
            selectedImageController.selectedImage.value = file;
          }
        },
        child: Container(
          width: double.infinity,
          height: MediaQuery.sizeOf(context).height * 0.35,
          color: Theme.of(context).colorScheme.primary,
          padding:
              EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.06),
          child: Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.2,
                  backgroundImage: selectedImageController
                              .selectedImage.value !=
                          null
                      ? FileImage(selectedImageController.selectedImage.value!)
                      : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
                ),
                Positioned(
                  right: MediaQuery.sizeOf(context).width * 0.0001,
                  bottom: MediaQuery.sizeOf(context).height * 0.001,
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.1,
                    height: MediaQuery.sizeOf(context).width * 0.1,
                    child: Image.network(
                        "https://cdn-icons-png.flaticon.com/512/5904/5904483.png"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _editProfileTextFields(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.04,
            vertical: MediaQuery.sizeOf(context).height * 0.03),
        child: Column(
          children: [
            EditProfileTextfield(
              labelText: 'Name',
              controller: nameController,
            ),
            EditProfileTextfield(
              labelText: 'Email',
              controller: emailController,
            ),
            EditProfileTextfield(
              labelText: 'Phone',
              controller: phoneController,
            ),
            EditProfileTextfield(
              labelText: 'Gender',
              controller: genderController,
            ),
          ],
        ),
      ),
    );
  }
}
