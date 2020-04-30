import 'package:barcode_scan/barcode_scan.dart';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;

mixin RegisterService {
  Future<bool> register(String uid) async {
    String url;
    var info = await _deviceInfo();

    if (info.isPhysicalDevice) {
      url = await _scan();
    } else {
      url = 'young-bayou-14201.herokuapp.com';
    }

    http.Response response =
        await http.get(Uri.https(url, '/client/user', {"uid": uid}));

    return response.statusCode == 201;
  }

  Future<AndroidDeviceInfo> _deviceInfo() {
    return DeviceInfoPlugin().androidInfo;
  }

  ScanOptions _scanOptions() {
    var strings = const {
      "cancel": "Cancel",
      "flash_on": "Flash on",
      "flash_off": "Flash off",
    };

    return ScanOptions(strings: strings, autoEnableFlash: false);
  }

  Future<String> _scan() async {
    try {
      ScanResult scanResult =
          await BarcodeScanner.scan(options: _scanOptions());

//      print(scanResult.type); // The result type (barcode, cancelled, failed)
//      print(scanResult.rawContent); // The barcode content
//      print(scanResult.format); // The barcode format (as enum)
//      print(scanResult.formatNote); // If a unknown format was scanned this field contains a not

      RegExp exp = new RegExp(
          r"https:\/\/young-bayou-14201\.herokuapp\.com\/client\/user");
      bool valid = exp.hasMatch(scanResult.rawContent);

      if (valid) {
        return scanResult.rawContent;
      }
    } catch (error) {
      print(error);
    }
    return null;
  }
}
