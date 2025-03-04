// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class WebViewerScreen extends StatefulWidget {
//   String link,title;
//  WebViewerScreen({super.key,required this.link,required this.title});

//   @override
//   State<WebViewerScreen> createState() => _WebViewerScreenState();
// }

// class _WebViewerScreenState extends State<WebViewerScreen> {


//   late WebViewController controller;
//   int progress = 0;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     controller = WebViewController()
//   ..setJavaScriptMode(JavaScriptMode.unrestricted)
//   ..setNavigationDelegate(
//     NavigationDelegate(
//       onProgress: (int progress) {
//         // Update loading bar.
//         setState(() {
//           this.progress = progress;
//         });
//       },
//       onPageStarted: (String url) {},
//       onPageFinished: (String url) {},
//       onHttpError: (HttpResponseError error) {},
//       onWebResourceError: (WebResourceError error) {},
//     ),
//   )
//   ..loadRequest(Uri.parse(widget.link));
//   }

//   @override
//   Widget build(BuildContext context) {


//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body:SizedBox(
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           children: [
//             LinearProgressIndicator(value: progress / 100,color: MAIN_COLOR,),
//             Expanded(flex:9,child: WebViewWidget(controller: controller))
//           ],
//         ),
//       ));
//   }
// }
