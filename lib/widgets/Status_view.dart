import 'package:flutter/material.dart';
import 'package:camera_test/models/recognition_model.dart';

class StatusCard extends StatefulWidget {
  late Recognition recognition;

  StatusCard({required this.recognition, super.key});

  @override
  State<StatusCard> createState() => _StatusCardState();
}

class _StatusCardState extends State<StatusCard> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 3,
          child: Text(
            widget.recognition.label,
            style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
                fontSize: 20.0),
          )),
      Expanded(
          flex: 7,
          child: SizedBox(
              height: 32.0,
              child: Stack(
                children: [
                  LinearProgressIndicator(
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                    value: widget.recognition.score,
                    backgroundColor: Colors.redAccent.withOpacity(0.2),
                    minHeight: 50.0,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${(widget.recognition.score * 100).toStringAsFixed(0)}%',
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
