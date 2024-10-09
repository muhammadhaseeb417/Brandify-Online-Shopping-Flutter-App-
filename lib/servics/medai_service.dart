import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MediaService {
  // Fixed typo in the class name
  final ImagePicker _imagePicker = ImagePicker();

  MediaService();

  Future<File?> getImageFromGallery() async {
    try {
      XFile? file = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (file != null) {
        return File(file.path); // Return the selected file
      } else {
        print("No image selected");
        return null; // Return null if no file is selected
      }
    } catch (e) {
      print("Error picking image: $e"); // Print the error message
      return null; // Return null in case of an error
    }
  }
}
