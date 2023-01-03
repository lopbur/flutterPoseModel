import 'package:flutter/material.dart';
import 'package:pose_webview_test/model/recognition_model.dart';

class StatusBar extends StatefulWidget {
  final Recognition re;
  const StatusBar({Key? key, required this.re}) : super(key: key);

  @override
  State<StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            widget.re.label ?? "",
          ),
        ),
        Expanded(
            flex: 8,
            child: Stack(
              children: [
                LinearProgressIndicator(
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                  value: widget.re.confidence,
                  backgroundColor: Colors.redAccent.withOpacity(0.2),
                  minHeight: 40,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${((widget.re.confidence ?? 0) * 100.0).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
