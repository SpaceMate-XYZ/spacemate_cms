# Functional Programming Guidelines

This document outlines the patterns and practices for using functional programming concepts in the Spacemate CMS project.

## Table of Contents
1. [Error Handling with fpdart](#error-handling-with-fpdart)
2. [Result Pattern](#result-pattern)
3. [Repository Pattern](#repository-pattern)
4. [Testing](#testing)
5. [Common Patterns](#common-patterns)
6. [Performance Considerations](#performance-considerations)

## Error Handling with fpdart

### Either Type

We use `Either<L, R>` from `fpdart` to represent operations that can fail:
- `Left<L, R>` represents a failure (conventionally holds an error)
- `Right<L, R>` represents a success (holds the result value)

```dart
import 'package:fpdart/fpdart.dart';

// Success case
final success = Right<String, int>(42);

// Failure case
final failure = Left<String, int>('Error occurred');
```

### TaskEither

For async operations, use `TaskEither` which is an async version of `Either`:

```dart
TaskEither<Failure, User> getUser(String id) {
  return TaskEither.tryCatch(
    () async => await api.getUser(id),
    (error, stackTrace) => ServerFailure('Failed to get user'),
  );
}
```

## Result Pattern

### Basic Usage

```dart
// In repository
Future<Either<Failure, Data>> fetchData() async {
  try {
    final result = await dataSource.getData();
    return Right(result);
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  }
}

// In bloc/cubit
final result = await repository.fetchData();
return result.fold(
  (failure) => emit(ErrorState(failure.message)),
  (data) => emit(SuccessState(data)),
);
```

## Repository Pattern

### Structure

```dart
abstract class MenuRepository {
  Future<Either<Failure, List<MenuItem>>> getMenuItems();
}

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource remoteDataSource;
  final MenuLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  // ... constructor ...

  @override
  Future<Either<Failure, List<MenuItem>>> getMenuItems() async {
    try {
      if (await networkInfo.isConnected) {
        final items = await remoteDataSource.getMenuItems();
        await localDataSource.cacheMenuItems(items);
        return Right(items);
      } else {
        final cachedItems = await localDataSource.getCachedMenuItems();
        return Right(cachedItems);
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
```

## Testing

### Unit Testing Repositories

```dart
group('MenuRepository', () {
  late MenuRepositoryImpl repository;
  late MockMenuRemoteDataSource mockRemoteDataSource;
  late MockMenuLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockMenuRemoteDataSource();
    mockLocalDataSource = MockMenuLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    
    repository = MenuRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getMenuItems', () {
    test('should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getMenuItems())
          .thenAnswer((_) async => tMenuItems);

      // act
      final result = await repository.getMenuItems();

      // assert
      verify(mockRemoteDataSource.getMenuItems());
      expect(result, equals(Right(tMenuItems)));
    });
  });
});
```

## Common Patterns

### Chaining Operations

```dart
final result = await repository.getUser(userId)
  .flatMap((user) => repository.getUserProfile(user.id))
  .flatMap((profile) => repository.updateLastSeen(profile.userId));
```

### Error Recovery

```dart
final result = await repository.getData()
  .flatMap((data) => processData(data))
  .getOrElse((failure) => handleError(failure));
```

## Performance Considerations

1. **Lazy Evaluation**
   - Use `Task` and `TaskEither` for expensive operations
   - They won't execute until explicitly run

2. **Memory Usage**
   - Be mindful of chaining many operations
   - Consider using `Option` for nullable values

3. **Error Handling**
   - Always handle both success and failure cases
   - Provide meaningful error messages

## Best Practices

1. **Immutability**
   - Prefer immutable data structures
   - Use `freezed` for data classes

2. **Pure Functions**
   - Write pure functions when possible
   - Makes code more predictable and testable

3. **Type Safety**
   - Leverage Dart's type system
   - Use sealed classes for state management

4. **Documentation**
   - Document complex operations
   - Add examples for common use cases

## Further Reading

- [fpdart documentation](https://sandromaglione.com/fpdart/)
- [Functional Programming in Dart](https://dart.dev/guides/language/effective-dart/usage#prefer-using-core-collection-apis)
- [Error Handling in Dart](https://dart.dev/guides/language/effective-dart/usage#dont-catch-error-unless-you-mean-to)
