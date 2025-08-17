import 'package:dartz/dartz.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/features/menu/data/models/screen_model.dart';

abstract class MenuRemoteDataSource {
  /// Fetches a list of screens from the remote server.
  ///
  /// - [placeId]: The place ID to fetch menu items for.
  ///
  /// Returns a [Future] that completes with either a [Failure] or a list of [ScreenModel].
  Future<Either<Failure, List<ScreenModel>>> getMenuItems({
    String? placeId,
  });

  /// Fetches menu grids tailored for a user from the backend integration endpoint.
  ///
  /// - [placeId]: The place ID to fetch grids for.
  /// - [authToken]: Optional bearer token to use for the request if not supplied via the Dio client.
  ///
  /// Returns a [Future] that completes with either a [Failure] or a list of [ScreenModel].
  Future<Either<Failure, List<ScreenModel>>> getMenuGridsForUser({
    String? placeId,
    String? authToken,
  });
}
