import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;

  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    // Dart client
    _socket = IO.io('https://api-buses.onrender.com/', {
      'transports': ['websocket'],
      'autoConnect': false
    });

    _socket.onConnect((_) {
      if (kDebugMode) {
        print('cliente conectado');
      }
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket.onConnectError((data) => print(data));

    _socket.on('disconnect', (_) {
      if (kDebugMode) {
        print('cliente desconectado');
      }
      _serverStatus = ServerStatus.offline;

      notifyListeners();
    });
  }
}
