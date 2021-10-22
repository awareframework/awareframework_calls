import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:awareframework_calls/awareframework_calls.dart';

void main() {
  const MethodChannel channel = MethodChannel('awareframework_calls');

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
    expect(await AwareframeworkCalls.platformVersion, '42');
  });
}
