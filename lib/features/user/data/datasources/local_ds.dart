import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

abstract class UserLocalDatasource {
  // add image
  Future<Uint8List?> addFileImage(Map<String, dynamic> params);
}

class UserLocalDatasourceImpl implements UserLocalDatasource {
  @override
  Future<Uint8List?> addFileImage(Map<String, dynamic> params) async {
    
    try {
      final image = await ImagePicker().pickImage(source: params["source"]);
      final byte = await image?.readAsBytes();
      return byte;
    } catch (e) {
      throw Exception("Error uploading the file");
    }
  }
}
