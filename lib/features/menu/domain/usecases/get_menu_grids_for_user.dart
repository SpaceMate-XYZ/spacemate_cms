import 'package:dartz/dartz.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/usecases/usecase.dart';
import 'package:spacemate/features/menu/domain/entities/screen_entity.dart';
import 'package:spacemate/features/menu/domain/repositories/menu_repository.dart';

class GetMenuGridsForUser implements UseCase<List<ScreenEntity>, GetMenuGridsForUserParams> {
  final MenuRepository repository;

  const GetMenuGridsForUser(this.repository);

  @override
  Future<Either<Failure, List<ScreenEntity>>> call(GetMenuGridsForUserParams params) async {
    return await repository.getMenuGridsForUser(placeId: params.placeId, authToken: params.authToken);
  }
}

class GetMenuGridsForUserParams {
  final String? placeId;
  final String? authToken;

  const GetMenuGridsForUserParams({this.placeId, this.authToken});
}
