import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Request storage permission for reading and writing files
  Future<bool> requestStoragePermission() async {
    try {
      // Check current status
      var status = await Permission.storage.status;
      
      // If already granted or limited (on some platforms)
      if (status.isGranted || status.isLimited) {
        return true;
      }
      
      // If permanently denied, open app settings
      if (status.isPermanentlyDenied) {
        return await openAppSettings();
      }
      
      // Request permission
      status = await Permission.storage.request();
      return status.isGranted || status.isLimited;
    } catch (e) {
      return false;
    }
  }
  
  /// Check if storage permission is granted
  Future<bool> hasStoragePermission() async {
    try {
      final status = await Permission.storage.status;
      return status.isGranted || status.isLimited;
    } catch (e) {
      return false;
    }
  }
  
  /// Open app settings to manually grant permissions
  Future<bool> openAppSettings() async {
    try {
      final opened = await openAppSettings();
      return opened;
    } catch (e) {
      return false;
    }
  }
}
