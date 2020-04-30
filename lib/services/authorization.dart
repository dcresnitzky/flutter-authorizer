import 'package:device_info/device_info.dart';
import 'package:authorizor/models/authorization.dart';
import 'package:authorizor/repositories/authorization.dart';
import 'package:http/http.dart';

class AuthorizationService {
  final AuthorizationRepository repository;

  AuthorizationService(this.repository);

  Future<bool> authorize(Authorization authorization, String userId) {
    return new Future<bool>(() async {
      if (authorization.isExpired()) {
        throw new Exception('Authorization is expired');
      }

      AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;

      Map body = {
        'denied': false,
        'userId': userId,
        'authId': authorization.id,
        'device': deviceInfo.toString()
      };

      Response response = await _httpRequest(authorization.callback, body);

      return response.statusCode == 200;
    });
  }

  Future<bool> delete(Authorization authorization, String userId) {
    return new Future<bool>(() async {
      if (authorization.isExpired()) {
        throw new Exception('Authorization is expired');
      }

      AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;

      Map body = {
        'denied': true,
        'userId': userId,
        'authId': authorization.id,
        'device': deviceInfo.toString()
      };

      Response response = await _httpRequest(authorization.callback, body);

      return response.statusCode == 200;
    });
  }

  Future<Response> _httpRequest(url, body) async {
    return await post(url, body: body);
  }

  Stream<dynamic> list(String uid) {
    return repository.list(uid);
  }
}
