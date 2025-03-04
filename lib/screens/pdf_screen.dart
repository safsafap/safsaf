import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/translator/app-translations.dart';
import 'package:pdfrx/pdfrx.dart';

class PdfScreen extends StatefulWidget {
  String path;
  PdfScreen({super.key, required this.path});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pdf Viewer".tr),
        ),
        body: PdfViewer.uri(Uri.parse(ORDERS_PDF + widget.path)));
  }
}
