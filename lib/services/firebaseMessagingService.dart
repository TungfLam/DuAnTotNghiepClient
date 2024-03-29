
import 'package:appclient/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
class FirebaseMessagingService{
  final _messaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _messaging.requestPermission();
    final fCMToken = await _messaging.getToken();
    print("token : $fCMToken");

    FirebaseMessaging.onMessage.listen((message) {

      print(message.data);
      if(message.notification!.title.toString() == "Messenger"){
        return;
      }
      LocalNotifications2.showNotification(message.notification!.title.toString(), message.notification!.body.toString(), 'item x');

    });
  }

  Future<String> getToken() async{
    final fCMToken = await _messaging.getToken();
    return fCMToken!;
  }

  void isTokenRefresh() async {
    _messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

}