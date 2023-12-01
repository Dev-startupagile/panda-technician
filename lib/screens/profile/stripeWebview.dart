// Import for Android features.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter/webview_flutter.dart';
// Import for iOS features.

class StripeWebView extends StatefulWidget {
  StripeWebView({super.key, required this.stripeUrl});
  final Uri stripeUrl;
  @override
  State<StripeWebView> createState() => _StripeWebViewState();
}

class _StripeWebViewState extends State<StripeWebView> {
  WebViewController webController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.yo.j/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    webController.loadRequest(widget.stripeUrl);
  }

  @override
  Widget build(BuildContext context) {
    // webController.loadRequest(widget.stripeUrl);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add Your Payment Method',
            style: TextStyle(
                color: Color(0xFF272727),
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Lato'),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF4B778D),
            ),
          ),
        ),
        body: Container(
          child: WebViewWidget(controller: webController),
        ));
  }
}
