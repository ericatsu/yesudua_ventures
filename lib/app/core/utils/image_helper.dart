import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageHelper {
  static final ImagePicker _picker = ImagePicker();

  // Check if running on desktop
  static bool get isDesktop {
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  // Pick image from gallery (works on all platforms)
  static Future<String?> pickImageFromGallery() async {
    try {
      if (isDesktop) {
        // Use file_picker for desktop platforms
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
        );

        if (result != null && result.files.single.path != null) {
          return await _saveImageToAppDirectory(result.files.single.path!);
        }
        return null;
      } else {
        // Use image_picker for mobile platforms
        final XFile? image = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 800,
          maxHeight: 800,
          imageQuality: 85,
        );

        if (image != null) {
          return await _saveImageToAppDirectory(image.path);
        }
        return null;
      }
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
      return null;
    }
  }

  // Pick image from camera (mobile only)
  static Future<String?> pickImageFromCamera() async {
    try {
      if (isDesktop) {
        debugPrint('Camera is not available on desktop platforms');
        return null;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        return await _saveImageToAppDirectory(image.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image from camera: $e');
      return null;
    }
  }

  // Save image to app directory
  static Future<String> _saveImageToAppDirectory(String sourcePath) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String imagesDir = path.join(appDir.path, 'inventory_images');

    // Create directory if it doesn't exist
    await Directory(imagesDir).create(recursive: true);

    // Generate unique filename
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String extension = path.extension(sourcePath);
    final String fileName = 'item_$timestamp$extension';
    final String savedPath = path.join(imagesDir, fileName);

    // Copy file to app directory
    await File(sourcePath).copy(savedPath);

    return savedPath;
  }

  // Delete image from storage
  static Future<bool> deleteImage(String imagePath) async {
    try {
      final File file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting image: $e');
      return false;
    }
  }

  // Check if path is a local file or asset
  static bool isLocalFile(String imagePath) {
    return !imagePath.startsWith('assets/') &&
        !imagePath.startsWith('lib/') &&
        File(imagePath).existsSync();
  }

  // Show image picker dialog (adaptive for mobile/desktop)
  static Future<String?> showImageSourceDialog(BuildContext context) async {
    if (isDesktop) {
      // Desktop: Only show gallery option
      return await pickImageFromGallery();
    }

    // Mobile: Show both gallery and camera options
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final imagePath = await pickImageFromGallery();
                  if (context.mounted) {
                    Navigator.pop(context, imagePath);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  final imagePath = await pickImageFromCamera();
                  if (context.mounted) {
                    Navigator.pop(context, imagePath);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  // Alternative: Show bottom sheet (better UX for mobile)
  static Future<String?> showImageSourceBottomSheet(
    BuildContext context,
  ) async {
    if (isDesktop) {
      return await pickImageFromGallery();
    }

    return await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final imagePath = await pickImageFromGallery();
                  if (context.mounted) {
                    Navigator.pop(context, imagePath);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final imagePath = await pickImageFromCamera();
                  if (context.mounted) {
                    Navigator.pop(context, imagePath);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
