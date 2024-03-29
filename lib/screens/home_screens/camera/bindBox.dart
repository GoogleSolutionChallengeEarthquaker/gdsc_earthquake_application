import 'package:flutter/material.dart';
import 'dart:math' as math;

class BindBox extends StatelessWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;

  const BindBox(
      this.results,
      this.previewH,
      this.previewW,
      this.screenH,
      this.screenW,
      {super.key}
      );

  @override
  Widget build(BuildContext context) {
    List<Widget> renderBoxes() {
      return results.map((re) {
        var x0 = re["rect"]["x"];
        var _w = re["rect"]["w"];
        var _y = re["rect"]["y"];
        var _h = re["rect"]["h"];
        var scaleW, scaleH, x, y, w, h;

        if (screenH / screenW > previewH / previewW) {
          scaleW = screenH / previewH * previewW;
          scaleH = screenH;
          var difW = (scaleW - screenW) / scaleW;
          x = (x0 - difW / 2) * scaleW;
          w = _w * scaleW;
          if (x0 < difW / 2) w -= (difW / 2 - x0) * scaleW;
          y = _y * scaleH;
          h = _h * scaleH;
        }
        else {
          scaleH = screenW / previewW * previewH;
          scaleW = screenW;
          var difH = (scaleH - screenH) / scaleH;
          x = x0 * scaleW;
          w = _w * scaleW;
          y = (_y - difH / 2) * scaleH;
          h = _h * scaleH;
          if (_y < difH / 2) h -= (difH / 2 - _y) * scaleH;
        }

        String labelText = "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%";
        // Belirli nesneler için uyarı metni ekleme
        if (re["detectedClass"] == "book" || re["detectedClass"] == "chair") {
          labelText += " (Warning! This object can be dangerous in earthquake.)"; // Uyarı mesajı ekleniyor
        }

        return Positioned(
          left: math.max(0, x),
          top: math.max(0, y),
          width: w,
          height: h,
          child: Container(
            padding: const EdgeInsets.only(top: 5.0, left: 5.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
                width: 3.0,
              ),
            ),
            child: Text(
              labelText,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList();
    }

    return Stack(
      children: renderBoxes(),
    );
  }
}