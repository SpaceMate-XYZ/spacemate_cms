import 'package:get_it/get_it.dart';
import 'package:spacemate/core/network/dio_client.dart';
import 'package:spacemate/core/network/network_info.dart';
import 'package:spacemate/features/carousel/data/repositories/strapi_carousel_repository_impl.dart';
import 'package:spacemate/features/carousel/domain/repositories/carousel_repository.dart';
import 'package:spacemate/features/carousel/domain/usecases/get_carousel_items.dart';
import 'package:spacemate/features/carousel/presentation/bloc/carousel_bloc.dart';

final getIt = GetIt.instance;

void initCarouselFeature() {
  // Bloc
  getIt.registerFactory<CarouselBloc>(
    () => CarouselBloc(getCarouselItems: getIt<GetCarouselItems>()),
  );

  // Use cases
  getIt.registerLazySingleton<GetCarouselItems>(
    () => GetCarouselItems(getIt<CarouselRepository>()),
  );

  // Repository
  getIt.registerLazySingleton<CarouselRepository>(
    () => StrapiCarouselRepository(
      httpClient: getIt<DioClient>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );
}
