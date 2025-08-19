import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  static final ReceivePort _port = ReceivePort();

  static Future<void> initialize() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();

      // FlutterDownloader and isolate callbacks are not supported on web.
      // Avoid calling into platform-specific background APIs when running in browser.
      if (kIsWeb) {
        debugPrint('DownloadService: running on web  skipping FlutterDownloader initialization');
        return;
      }

      // Initialize FlutterDownloader
      try {
        await FlutterDownloader.initialize(
          debug: false, // Set to true for development
          ignoreSsl: true, // Set to false in production
        );
      } on MissingPluginException catch (e) {
        // In test or other environments platform plugin may be missing.
        debugPrint('DownloadService: FlutterDownloader plugin missing, skipping initialization: $e');
        return;
      }

      // Register the callback once
      FlutterDownloader.registerCallback(downloadCallback);

      // Listen to download progress
      IsolateNameServer.registerPortWithName(
        _port.sendPort,
        'downloader_send_port',
      );

      _port.listen((dynamic data) {
        final taskId = data[0] as String;
        final status = data[1] as DownloadTaskStatus;
        final progress = data[2] as int;

        debugPrint('Download task ($taskId) is in status $status and progress $progress');
      });
    } catch (e) {
      debugPrint('Error initializing DownloadService: $e');
      rethrow;
    }
  }
  
  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    DownloadTaskStatus taskStatus;
    
    switch (status) {
      case 0:
        taskStatus = DownloadTaskStatus.undefined;
        break;
      case 1:
        taskStatus = DownloadTaskStatus.running;
        break;
      case 2:
        taskStatus = DownloadTaskStatus.complete;
        break;
      case 3:
        taskStatus = DownloadTaskStatus.failed;
        break;
      case 4:
        taskStatus = DownloadTaskStatus.canceled;
        break;
      case 5:
        taskStatus = DownloadTaskStatus.paused;
        break;
      default:
        taskStatus = DownloadTaskStatus.undefined;
    }
    
    send?.send([id, taskStatus, progress]);
  }

  static Future<String> getDownloadDirectory() async {
    if (kIsWeb) {
      // No file system access on web; return empty string and let callers handle it.
      debugPrint('DownloadService: getDownloadDirectory() not available on web');
      return '';
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final downloadDir = '${directory.path}/downloads';

      // Create directory if it doesn't exist
      final dir = Directory(downloadDir);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      return downloadDir;
    } catch (e) {
      debugPrint('Error getting download directory: $e');
      rethrow;
    }
  }
  
  static Future<void> dispose() async {
    try {
      IsolateNameServer.removePortNameMapping('downloader_send_port');
      _port.close();
    } catch (e) {
      debugPrint('Error disposing DownloadService: $e');
    }
  }
}
