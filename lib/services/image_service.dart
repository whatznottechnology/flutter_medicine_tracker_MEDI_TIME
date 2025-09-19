import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import '../l10n/app_localizations.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  /// Check and request necessary permissions
  static Future<bool> _checkPermissions(ImageSource source) async {
    if (source == ImageSource.camera) {
      final cameraStatus = await Permission.camera.status;
      if (cameraStatus.isDenied) {
        final result = await Permission.camera.request();
        return result.isGranted;
      }
      return cameraStatus.isGranted;
    } else {
      // For gallery access, we need storage permission on older Android versions
      if (Platform.isAndroid) {
        final storageStatus = await Permission.storage.status;
        if (storageStatus.isDenied) {
          final result = await Permission.storage.request();
          return result.isGranted;
        }
        return storageStatus.isGranted;
      }
      return true; // iOS doesn't need explicit permission for gallery
    }
  }

  /// Pick an image from gallery or camera
  static Future<String?> pickImage({
    ImageSource source = ImageSource.gallery,
    int imageQuality = 85,
  }) async {
    try {
      // Check permissions first
      final hasPermission = await _checkPermissions(source);
      if (!hasPermission) {
        debugPrint('Permission denied for image source: $source');
        return null;
      }

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: imageQuality,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile == null) return null;

      // Save the image to app directory
      final String? savedPath = await _saveImageToAppDirectory(pickedFile);
      return savedPath;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  /// Save picked image to app's permanent directory
  static Future<String?> _saveImageToAppDirectory(XFile pickedFile) async {
    try {
      // Get app documents directory
      final Directory appDir = await getApplicationDocumentsDirectory();
      final Directory imagesDir = Directory('${appDir.path}/medicine_images');
      
      // Create directory if it doesn't exist
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      // Generate unique filename
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(pickedFile.path)}';
      final String newPath = '${imagesDir.path}/$fileName';

      // Copy file to new location
      final File originalFile = File(pickedFile.path);
      await originalFile.copy(newPath);

      return newPath;
    } catch (e) {
      debugPrint('Error saving image: $e');
      return null;
    }
  }

  /// Delete an image file
  static Future<bool> deleteImage(String imagePath) async {
    try {
      final File imageFile = File(imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting image: $e');
      return false;
    }
  }

  /// Check if image file exists
  static Future<bool> imageExists(String imagePath) async {
    try {
      final File imageFile = File(imagePath);
      return await imageFile.exists();
    } catch (e) {
      return false;
    }
  }

  /// Get image file
  static File? getImageFile(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;
    return File(imagePath);
  }

  /// Show image picker dialog
  static Future<String?> showImagePickerDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    return await showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.selectImageSource),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(l10n.gallery),
                onTap: () async {
                  Navigator.of(context).pop();
                  final String? imagePath = await pickImage(source: ImageSource.gallery);
                  if (context.mounted) {
                    Navigator.of(context).pop(imagePath);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(l10n.camera),
                onTap: () async {
                  Navigator.of(context).pop();
                  final String? imagePath = await pickImage(source: ImageSource.camera);
                  if (context.mounted) {
                    Navigator.of(context).pop(imagePath);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
          ],
        );
      },
    );
  }

  /// Clean up old unused images
  static Future<void> cleanupUnusedImages(List<String> usedImagePaths) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final Directory imagesDir = Directory('${appDir.path}/medicine_images');
      
      if (!await imagesDir.exists()) return;

      final List<FileSystemEntity> files = await imagesDir.list().toList();
      
      for (final FileSystemEntity file in files) {
        if (file is File) {
          final String filePath = file.path;
          if (!usedImagePaths.contains(filePath)) {
            try {
              await file.delete();
              debugPrint('Deleted unused image: $filePath');
            } catch (e) {
              debugPrint('Error deleting unused image: $e');
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error cleaning up images: $e');
    }
  }
}