import 'package:dio/dio.dart';
import 'package:spacemate/features/menu/data/models/screen_model.dart';

abstract class MenuRemoteDataSource {
  /// Fetches a list of screens from the remote server.
  ///
  /// - [slug]: The slug of the screen to fetch.
  /// - [locale]: The locale for which to fetch the screens.
  /// - [cancelToken]: A token to cancel the request.
  ///
  /// Returns a [Future] that completes with a list of [ScreenModel].
  /// Throws a [ServerException] if the request fails.
  Future<List<ScreenModel>> getMenuItems({
    required String slug,
    String? locale,
  });
}
