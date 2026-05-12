import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/connectivity_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _urlController;
  final ConnectivityService _connectivity = ConnectivityService();
  bool _isTesting = false;
  String? _testResult;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(
      text: StorageService.getDashboardUrl(),
    );
  }

  Future<void> _testConnection() async {
    setState(() {
      _isTesting = true;
      _testResult = null;
    });

    final url = _urlController.text.trim();
    final ok = await _connectivity.testUrl(url);

    setState(() {
      _isTesting = false;
      _testResult = ok ? '✓ Server reachable' : '✗ Cannot reach server';
    });
  }

  Future<void> _save() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    await StorageService.setDashboardUrl(url);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('URL saved. Restart the app to apply.'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Server URL
          Text('Dashboard URL',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _urlController,
            decoration: InputDecoration(
              hintText: 'http://127.0.0.1:9119',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => _urlController.clear(),
              ),
              helperText:
                  'Tailscale IP or hostname of your Hermes dashboard.',
            ),
            keyboardType: TextInputType.url,
            autocorrect: false,
          ),
          const SizedBox(height: 12),

          // Test button
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _isTesting ? null : _testConnection,
                icon: _isTesting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.wifi_find),
                label: const Text('Test Connection'),
              ),
              const SizedBox(width: 12),
              if (_testResult != null)
                Text(
                  _testResult!,
                  style: TextStyle(
                    color: _testResult!.startsWith('✓')
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 32),

          // About
          Text('About', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('HermesHQ v0.1.0',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(
                    'Native macOS & iOS companion for Hermes Agent.\n'
                    'Connects to your dashboard over Tailscale.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _save,
        icon: const Icon(Icons.save),
        label: const Text('Save & Restart'),
      ),
    );
  }
}
