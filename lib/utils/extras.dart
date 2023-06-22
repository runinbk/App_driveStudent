import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

Future<Uint8List> loadAsset(
  String path, {
  int width = 50,
}) async {
  ByteData assetData = await rootBundle.load(path);
  final Uint8List bytes = assetData.buffer.asUint8List();
  final ui.Codec codec = await ui.instantiateImageCodec(
    bytes,
    targetWidth: width,
  );

  final ui.FrameInfo frame = await codec.getNextFrame();
  final ByteData? imageData = await frame.image.toByteData(format: ui.ImageByteFormat.png);

  if (imageData != null) {
    return imageData.buffer.asUint8List();
  } else {
    throw Exception("Failed to convert image to ByteData.");
  }
}


Future<Uint8List> loadImageFromNetwork(
  String url, {
  int width = 50,
  int height = 50,
}) async {
  final http.Response response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Uint8List bytes = response.bodyBytes;
    final ui.Codec codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: width,
      targetHeight: height,
    );

    final ui.FrameInfo frame = await codec.getNextFrame();
    final ByteData? imageData = await frame.image.toByteData(format: ui.ImageByteFormat.png);

    if (imageData != null) {
      return imageData.buffer.asUint8List();
    } else {
      throw Exception("Failed to convert image to ByteData.");
    }
  }

  throw Exception("Download failed. Status code: ${response.statusCode}");
}

double getCoordsRotation(LatLng currentPosition, LatLng lastPosition) {
  final dx = math.cos(math.pi / 180 * lastPosition.latitude) *
      (currentPosition.longitude - lastPosition.longitude);
  final dy = currentPosition.latitude - lastPosition.latitude;
  final angle = math.atan2(dy, dx);

  return 90 - angle * 180 / math.pi;
}

