import 'package:appclient/services/baseApi.dart';
import 'package:appclient/services/local_notification.dart';
import 'package:socket_io_client/socket_io_client.dart';

void connectSocket() async {
  String deviceId = '';
  final socket = io('http://$BASE_API:6868/' , <String , dynamic>{
    'transports': ['websocket'],
  });

  socket.on('connect', (_) {
    print('Connected to server');
  });

  socket.on('push-notification', (data) async {
    print('Received notification: $data');
    await showNotification(data['title'] , data['content']);
  });

  socket.on('push-notification-single', (data) {
    print('Received notification single: $data');
  });

  void registerDevice() {
    socket.emit('register-device', deviceId);
  }
}