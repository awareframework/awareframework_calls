import 'package:test/test.dart';

import 'package:awareframework_calls/awareframework_calls.dart';

void main(){
  test("test sensor config", (){
    var config = CallsSensorConfig();

    expect(config.debug, false);
  });
}