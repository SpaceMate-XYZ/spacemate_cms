import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacemate/core/network/network_info.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late MockConnectivity mockConnectivity;
  late NetworkInfoImpl networkInfo;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfo = NetworkInfoImpl(mockConnectivity);
  });

  test('isConnected returns true for wifi', () async {
    when(() => mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.wifi);

    final result = await networkInfo.isConnected;
    expect(result, isTrue);
  });

  test('isConnected returns false for none', () async {
    when(() => mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.none);

    final result = await networkInfo.isConnected;
    expect(result, isFalse);
  });

  test('connectivityResult returns underlying result', () async {
    when(() => mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.mobile);

    final res = await networkInfo.connectivityResult;
    expect(res, equals(ConnectivityResult.mobile));
  });
}
