import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

// Cloudinary credentials provided by the user
const String _cloudName = 'x7zv1mzc';
const String _uploadPreset = 'ml_default';

/// Uploads an image file to Cloudinary and returns the secure network URL.
/// If the upload fails, returns null.
Future<String?> uploadImageToCloudinary(File imageFile) async {
  try {
    final response = await Dio().post(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
      data: FormData.fromMap({
        'upload_preset': _uploadPreset,
        'file': await MultipartFile.fromFile(imageFile.path),
      }),
    );

    if (response.statusCode == 200) {
      log('responseData: ${response.data}');
      return response.data['secure_url'];
    } else {
      log('Failed to upload image. Status code: ${response.statusCode}');
      return null;
    }
  } on DioException catch (e) {
    log('Error uploading image: ${e.message}');
    return null;
  } catch (e) {
    log('Error during Cloudinary upload: $e');
    return null;
  }
}
