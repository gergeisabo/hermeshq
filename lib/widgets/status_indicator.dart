import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';

class StatusIndicator extends StatelessWidget {
  final ServerStatus status;

  const StatusIndicator({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, label, icon) = switch (status) {
      ServerStatus.online => (
          Colors.greenAccent.shade700,
          'Connected',
          Icons.check_circle_outline,
        ),
      ServerStatus.offline => (
          Colors.redAccent,
          'Disconnected',
          Icons.cloud_off,
        ),
      ServerStatus.checking => (
          Colors.orangeAccent.shade700,
          'Connecting...',
          Icons.sync,
        ),
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: 26,
      color: color.withAlpha(40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
