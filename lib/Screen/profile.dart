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
    return  Scaffold(
       appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'thông tin cá nhân',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: const [],
      ),
      body: Container(
        padding: EdgeInsets.all(18),
        child: const SingleChildScrollView(
            child: Column(
              children: <Widget>[
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
                  
                
                Column(
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
                ),
              ],
            ),
        ),
      ));
    ;
  }
}
