import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/storage_service.dart';
import '../services/connectivity_service.dart';
import '../widgets/status_indicator.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final WebViewController _controller;
  final ConnectivityService _connectivity = ConnectivityService();
  StreamSubscription<ServerStatus>? _statusSub;
  ServerStatus _currentStatus = ServerStatus.checking;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initWebView();
    _statusSub = _connectivity.statusStream.listen((status) {
      if (mounted) setState(() => _currentStatus = status);
    });
  }

  Future<void> _initWebView() async {
    final url = StorageService.getDashboardUrl();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() {
              _isLoading = true;
              _errorMessage = null;
            });
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
            if (mounted) setState(() {
              _isLoading = false;
              _errorMessage = 'Cannot reach ${error.url}';
            });
          },
        ),
      )
      ..enableZoom(true)
      ..setBackgroundColor(const Color(0xFF0D0D0D));

    await _controller.loadRequest(Uri.parse(url));
  }

  Future<void> _reload() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    _controller.reload();
  }

  @override
  void dispose() {
    _statusSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Status bar
          StatusIndicator(status: _currentStatus),

          // WebView or error
          Expanded(
            child: Stack(
              children: [
                if (_errorMessage != null)
                  _buildErrorView()
                else
                  WebViewWidget(controller: _controller),

                if (_isLoading && _errorMessage == null)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'reload',
            onPressed: _reload,
            tooltip: 'Reload',
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'settings',
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            tooltip: 'Settings',
            child: const Icon(Icons.settings),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 64,
                color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(_errorMessage!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Make sure Tailscale is connected and the server is running.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _reload,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              child: const Text('Change server URL'),
            ),
          ],
        ),
      ),
    );
  }
}
