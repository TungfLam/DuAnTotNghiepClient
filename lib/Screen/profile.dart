import 'package:flutter/material.dart';

class profileScreen extends StatefulWidget {
  const profileScreen({super.key});

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class CardExample extends StatelessWidget {
  const CardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.album),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
          ],
        ),
      ),
    );
  }
}

class _profileScreenState extends State<profileScreen> {
  get child => null;

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    child: Icon(Icons.arrow_back),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(
                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Bùi Duy Quang" + " | " + "Hà Nội",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              Text("Description"),
                Padding(
                  padding: EdgeInsets.only(top: 40, bottom: 20,right: 20,left: 20),
                  child:
                   Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                ),
                Expanded(
                          flex: 2,
                          child: Text(
                         "Đơn hàng đã mua",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                                fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                  Icon(Icons.arrow_right),
                  ],
                )),
              
              Padding(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: Column(
                    children: [
                      // so dien thoai
                      Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Số điện thoại",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                          SizedBox(
                            height: 40, // <-- TextField height
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Colors.white),
                              child: TextField(
                                maxLines: null,
                                expands: true,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                    hintText: 'Nhập địa số điện thoại'),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // ho ten
                      Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Họ tên",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                          SizedBox(
                            height: 40, // <-- TextField height
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Colors.white),
                              child: TextField(
                                maxLines: null,
                                expands: true,
                                keyboardType: TextInputType.multiline,
                                decoration:
                                    InputDecoration(hintText: 'Nhập họ tên'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //ngay sinh
                      Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Ngày sinh",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                          SizedBox(
                            height: 40, // <-- TextField height
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Colors.white),
                              child: TextField(
                                maxLines: null,
                                expands: true,
                                keyboardType: TextInputType.multiline,
                                decoration:
                                    InputDecoration(hintText: 'Nhập ngày sinh'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // gioi tinh
                      Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Giới tính",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                          SizedBox(
                            height: 40, // <-- TextField height
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Colors.white),
                              child: TextField(
                                maxLines: null,
                                expands: true,
                                keyboardType: TextInputType.multiline,
                                decoration:
                                    InputDecoration(hintText: 'Nhập giới tính'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // email
                      Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Email",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                          SizedBox(
                            height: 40, // <-- TextField height
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Colors.white),
                              child: TextField(
                                maxLines: null,
                                expands: true,
                                keyboardType: TextInputType.multiline,
                                decoration:
                                    InputDecoration(hintText: 'Nhập email'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //tinh thanh
                      Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Thành phố",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                          SizedBox(
                            height: 40, // <-- TextField height
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Colors.white),
                              child: TextField(
                                maxLines: null,
                                expands: true,
                                keyboardType: TextInputType.multiline,
                                decoration:
                                    InputDecoration(hintText: 'Nhập Thành phố'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // quan huyen
                      Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Quận huyện",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                          SizedBox(
                            height: 40, // <-- TextField height
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Colors.white),
                              child: TextField(
                                maxLines: null,
                                expands: true,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                    hintText: 'Nhập quận huyện'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // dia chi
                      Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Địa chỉ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                          SizedBox(
                            height: 40, // <-- TextField height
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Colors.white),
                              child: TextField(
                                maxLines: null,
                                expands: true,
                                keyboardType: TextInputType.multiline,
                                decoration:
                                    InputDecoration(hintText: 'Nhập địa chỉ'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
      )),
    );
  }
}
