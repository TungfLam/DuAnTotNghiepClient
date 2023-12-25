import 'package:appclient/models/Notification_Model.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<StatefulWidget> createState() => NotificationPage();
}

class NotificationPage extends State<NotificationScreen> {
  List<NotificationModel> list = [
    NotificationModel(
        title: "Title",
        message:
            "Content Firebase có thể đã phát hiện quá nhièu yêu cầu xác minh SMS từ thiết bị của bạn trong một thời gian ngắn dẫn đến nghi ngờ hoạt động bất thường",
        dateTime: '20:12 14/20/2023',
        image: 'https://picsum.photos/250?image=9'),
    NotificationModel(
        title: "Title",
        message:
            "Content Firebase có thể đã phát hiện quá nhièu yêu cầu xác minh SMS từ thiết bị của bạn trong một thời gian ngắn dẫn đến nghi ngờ hoạt động bất thường",
        dateTime: '20:12 14/20/2023'),
    NotificationModel(
        title: "Title",
        message:
            "Content Firebase có thể đã phát hiện quá nhièu yêu cầu xác minh SMS từ thiết bị của bạn trong một thời gian ngắn dẫn đến nghi ngờ hoạt động bất thường",
        dateTime: '20:12 14/20/2023',
        image: 'https://picsum.photos/250?image=9'),
    NotificationModel(
        title: "Title",
        message:
            "Content Firebase có thể đã phát hiện quá nhièu yêu cầu xác minh SMS từ thiết bị của bạn trong một thời gian ngắn dẫn đến nghi ngờ hoạt động bất thường",
        dateTime: '20:12 14/20/2023'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Notification',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              // Handle the back button press here, such as navigating back
              Navigator.of(context).pop();
            },
          ),
          elevation: 0.5,
        ),
        body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            var notifi = list[index];
            return itemNotifi(context, notifi, index);
          },
        ));
  }
}

Widget itemNotifi(BuildContext context, NotificationModel? notifi, int index) {
  return Container(
    width: MediaQuery.of(context).size.width,
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: index % 2 == 0
          ? const Color.fromARGB(241, 210, 233, 243)
          : const Color.fromARGB(245, 245, 245, 255),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 1,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          notifi?.title ?? '',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notifi?.image != null)
              Image.network(notifi!.image!, width: 80, height: 80),
            Container(
              margin: EdgeInsets.only(left: notifi?.image != null ? 10 : 0),
              width: MediaQuery.of(context).size.width /
                  (notifi?.image != null ? 1.56 : 1.15),
              child: Text(
                notifi?.message ?? '',
                style: const TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            notifi?.dateTime ?? '',
            style: const TextStyle(fontSize: 16),
          ),
        )
      ],
    ),
  );
}
