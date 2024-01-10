
import 'package:appclient/services/local_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
class FirebaseMessagingService{
  final _messaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _messaging.requestPermission();
    final fCMToken = await _messaging.getToken();
    print("token : $fCMToken");

    FirebaseMessaging.onMessage.listen((message) {

      if(message.notification!.title.toString() == "Messenger"){
        return;
      }
      showNotification( message.notification!.title.toString(), message.notification!.body.toString());
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