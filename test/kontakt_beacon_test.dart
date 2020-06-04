import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kontakt_beacon/kontakt_beacon.dart';

void main() {
  const MethodChannel channel = MethodChannel('vaifat.planb.com/kontakt/beacon');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
//    expect(await KontaktBeacon.platformVersion, '42');
  });
}
