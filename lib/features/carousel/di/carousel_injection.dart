import 'package:get_it/get_it.dart';
import 'package:spacemate/core/network/dio_client.dart';
import 'package:spacemate/core/network/network_info.dart';
import 'package:spacemate/features/carousel/data/repositories/strapi_carousel_repository_impl.dart';
import 'package:spacemate/features/carousel/domain/repositories/carousel_repository.dart';
import 'package:spacemate/features/carousel/domain/usecases/get_carousel_items.dart';
import 'package:spacemate/features/carousel/presentation/bloc/carousel_bloc.dart';

final sl = GetIt.instance;

Future<void> initCarouselDependencies() async {
  // Repository
  if (!sl.isRegistered<CarouselRepository>()) {
    sl.registerLazySingleton<CarouselRepository>(
      () => StrapiCarouselRepositoryImpl(
        dioClient: sl<DioClient>(),
        networkInfo: sl<NetworkInfo>(),
      ),
    );
  }

  // Use cases
  if (!sl.isRegistered<GetCarouselItems>()) {
    sl.registerLazySingleton<GetCarouselItems>(
      () => GetCarouselItems(sl<CarouselRepository>()),
    );
  }

  // BLoC
  if (!sl.isRegistered<CarouselBloc>()) {
    sl.registerFactory(
      () => CarouselBloc(
        getCarouselItems: sl<GetCarouselItems>(),
      ),
    );
  }
}
