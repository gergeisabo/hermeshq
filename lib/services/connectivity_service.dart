import 'dart:async';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

enum ServerStatus { online, offline, checking }

class ConnectivityService {
  final _statusController = StreamController<ServerStatus>.broadcast();
  Timer? _timer;

  Stream<ServerStatus> get statusStream => _statusController.stream;

  void startMonitoring({Duration interval = const Duration(seconds: 30)}) {
    _timer?.cancel();
    _check();
    _timer = Timer.periodic(interval, (_) => _check());
  }

  void pauseMonitoring() => _timer?.cancel();

  void resumeMonitoring() {
    _check();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _check());
  }

  Future<void> _check() async {
    try {
      final url = StorageService.getDashboardUrl();
      final uri = Uri.parse(url).replace(path: '/api/health');
      final response =
          await http.get(uri).timeout(const Duration(seconds: 5));
      _statusController.add(
        response.statusCode == 200 ? ServerStatus.online : ServerStatus.offline,
      );
    } catch (_) {
      _statusController.add(ServerStatus.offline);
    }
  }

  Future<bool> testUrl(String url) async {
    try {
      final uri = Uri.parse(url).replace(path: '/api/health');
      final response =
          await http.get(uri).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _timer?.cancel();
    _statusController.close();
  }
}
