import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebView extends StatefulWidget {
  final String path;
  final Function(String) results;
  const WebView({Key? key, required this.path, required this.results})
      : super(key: key);

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(useHybridComposition: true),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  //define web view event handler
  late var onWebViewCreated = (InAppWebViewController controller) async {
    controller.addJavaScriptHandler(
        handlerName: "updater",
        callback: (args) {
          List predict = args[0];
          Map<String, double> mp = {};
          for (var element in predict) {
            mp[element["className"]] = element["probability"] * 1.0;
          }
          widget.results(const JsonEncoder().convert(mp));
        });
  };

  var onLoadStop = (InAppWebViewController controller, Uri? uri) async {
    controller.evaluateJavascript(
      source:
          'init(\'https://teachablemachine.withgoogle.com/models/L1bAAtj82/\')',
    );
  };

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialFile: widget.path,
      initialData: InAppWebViewInitialData(data: "asdasd"),
      initialOptions: options,
      onWebViewCreated: onWebViewCreated,
      onLoadStop: onLoadStop,
      androidOnPermissionRequest: (InAppWebViewController controller,
          String origin, List<String> resources) async {
        return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT);
      },
    );
  }
}
