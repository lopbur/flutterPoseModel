import 'package:flutter/material.dart';

class StatusCard extends StatefulWidget {
  late String classname;
  late double confidence;

  StatusCard({required this.classname, required this.confidence, super.key});

  @override
  State<StatusCard> createState() => _StatusCardState();
}

class _StatusCardState extends State<StatusCard> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 2,
          child: Text(
            widget.classname,
            style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
                fontSize: 20.0),
          )),
      Expanded(
          flex: 8,
          child: SizedBox(
              height: 32.0,
              child: Stack(
                children: [
                  LinearProgressIndicator(
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                    value: widget.confidence,
                    backgroundColor: Colors.redAccent.withOpacity(0.2),
                    minHeight: 50.0,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${(widget.confidence * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0),
                    ),
                  ),
                ],
              )))
    ]);
  }
}
