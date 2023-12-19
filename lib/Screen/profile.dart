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
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            toolbarHeight: 100,
            flexibleSpace: Container(
              color: Color.fromARGB(112, 137, 223, 255),
              child: const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.arrow_back),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "ADADAS",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Icon(Icons.menu),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 30, top: 10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                                'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      "Bùi Duy Quang",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Text(
                                    "ID: 234567777",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )
                                ],
                              ))
                        ],
                      ))
                ],
              ),
            ),
          ),
          body: const Stack(
            children: [
              Column(
                children: <Widget>[
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              SizedBox(
                                height: 40, // <-- TextField height
                                child: DecoratedBox(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              SizedBox(
                                height: 40, // <-- TextField height
                                child: DecoratedBox(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: TextField(
                                    maxLines: null,
                                    expands: true,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                        hintText: 'Nhập họ tên'),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              SizedBox(
                                height: 40, // <-- TextField height
                                child: DecoratedBox(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: TextField(
                                    maxLines: null,
                                    expands: true,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                        hintText: 'Nhập ngày sinh'),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              SizedBox(
                                height: 40, // <-- TextField height
                                child: DecoratedBox(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: TextField(
                                    maxLines: null,
                                    expands: true,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                        hintText: 'Nhập giới tính'),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              SizedBox(
                                height: 40, // <-- TextField height
                                child: DecoratedBox(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              SizedBox(
                                height: 40, // <-- TextField height
                                child: DecoratedBox(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: TextField(
                                    maxLines: null,
                                    expands: true,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                        hintText: 'Nhập Thành phố'),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              SizedBox(
                                height: 40, // <-- TextField height
                                child: DecoratedBox(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              SizedBox(
                                height: 40, // <-- TextField height
                                child: DecoratedBox(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: TextField(
                                    maxLines: null,
                                    expands: true,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                        hintText: 'Nhập địa chỉ'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ],
              ),
            ],
          )),
    );
  }
}
