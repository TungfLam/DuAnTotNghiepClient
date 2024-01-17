import 'dart:async';
import 'dart:io';

import 'package:appclient/services/baseApi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:image_picker/image_picker.dart';

class ChatBoxScreen extends StatefulWidget {
  const ChatBoxScreen({super.key});

  @override
  State<ChatBoxScreen> createState() => _ChatBoxScreenState();
}

class Conversation {
  final String id;
  final List<String> members;
  final String? createdAt;

  Conversation({required this.id, required this.members, this.createdAt});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['_id'],
      members: List<String>.from(json['members']),
      createdAt: json['createdAt'],
    );
  }
}

class _ChatBoxScreenState extends State<ChatBoxScreen> {
  String anhdd = '';
  String mail = '';
  String fname = '';
  String userid = ''; //id user
  List<Conversation> conversations = [];
  bool isLoading = true;
  late io.Socket socket;
  List<String> messages = [];
  TextEditingController recipientIdController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchConversations();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isLogin = prefs.getBool("isLogin");
    final String? idUser = prefs.getString("idUser");
    final String? avarta = prefs.getString("avata");
    final String? email = prefs.getString("email");
    final String? fullname = prefs.getString("fullname");
    print('tai khoan dang nhap $idUser');
    fetchConversations();
    if (mounted) {
      setState(() {
        userid = idUser ?? '';
        anhdd = avarta ?? '';
        mail = email ?? '';
        fname = fullname ?? '';
      });
    }
    if (isLogin == null) {
      return;
    }
    if (isLogin) {
    } else {}
  }

  Future<void> fetchConversations() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? idUser = prefs.getString("idUser");

      final response =
          await http.get(Uri.parse('$BASE_API/api/conversation/$idUser'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        setState(() {
          conversations = List<Conversation>.from(
              jsonData['data'].map((x) => Conversation.fromJson(x)));
          isLoading = false;
        });
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error fetching conversations: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Screen',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Conversation'),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final conversation = conversations[index];
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: NetworkImage(
                          '$BASE_API/imgMessage/659bdaf0da877cd9d80894f9_hwzscsulpsrsyjzarw4m.jpg'),
                    ),
                    title: const Text('ADADAS ONLINE'),
                    // subtitle: Text(conversation.members.join(' ')),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessageScreen(
                            conversationId: conversation.id,
                            userId: userid,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}

String formatCreatedAt(String createdAt) {
  try {
    initializeDateFormatting();
    DateTime dateTime = DateTime.parse(createdAt).toUtc();
    dateTime = dateTime
        .add(const Duration(hours: 7)); // Thêm 7 giờ để chuyển từ UTC sang ICT
    final DateFormat formatter = DateFormat('HH:mm - dd/MM/yyyy', 'vi_VN');
    final String formatted = formatter.format(dateTime);
    return formatted;
    // ...
  } catch (e) {
    print('Invalid date format: $createdAt');
    return 'Lỗi ngày';
  }
}

//==========================
class MessageScreen extends StatefulWidget {
  final String conversationId;
  final String userId;

  const MessageScreen({
    Key? key,
    required this.conversationId,
    required this.userId,
  }) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class Message {
  final String id;
  final String conversationId;
  final String sender;
  final String text;
  final String createdAt;

  Message(
      {required this.id,
      required this.conversationId,
      required this.sender,
      required this.createdAt,
      required this.text});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'] ?? '',
      conversationId: json['conversationId'] ?? '',
      sender: json['sender'] ?? '',
      text: json['text'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Message{id: $id, conversationId: $conversationId, sender: $sender, text: $text, createdAt: $createdAt}';
  }
}

class _MessageScreenState extends State<MessageScreen> {
  final ScrollController _controller = ScrollController();
  List<Message> messages = [];

  bool isLoading = true;
  late io.Socket socket;
  String userid = ''; //id user
  String mCurrentUserid = '';
  StreamController<Message> messageController = StreamController<Message>();
// ...

  @override
  void initState() {
    super.initState();
    fetchMessages();
    connectToServer();
  }

  void connectToServer() {
    try {
      // Khởi tạo kết nối Socket.IO
      socket = io.io(BASE_API, <String, dynamic>{
        'transports': ['websocket'],
      });

      socket.on('message', (data) async {
        if (data is Map<String, dynamic>) {
          String id = data['_id'];
          String conversationId = data['conversationId'];
          String sender = data['sender'];
          String text = data['text'];
          String createdAt = data['createdAt'];

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String? idUser = prefs.getString("idUser");

          final String firstMemberId =
              await fetchFirstMemberId(widget.conversationId, idUser!);

          Message newMessage = Message(
            id: id,
            conversationId: conversationId,
            sender: sender,
            text: text,
            createdAt: createdAt,
          );

          if (firstMemberId == sender) {
            print('nhận tin nhắn của người này');
            if (mounted) {
              setState(() {
                messages.insert(0, newMessage);
              });
            }
          } else {
            print('có tin nhắn mới');
          }
          // Thêm tin nhắn mới vào danh sách

          // Sử dụng 'text' và 'createdAt' tại đây

          print('Nhận được tin nhắn : $text ');
        } else {
          print('Unknown data type');
        }
      });

      // Lắng nghe sự kiện kết nối thành công
      socket.on('connect', (_) async {
        if (mounted) {
          // Kiểm tra xem widget còn "mounted" hay không
          print('1 Connected to server: ${socket.id}');
          String? socketId = socket.id;
          if (socketId != null) {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            final String? idUser = prefs.getString("idUser");
            setSocketId(idUser!, socketId);

            final String firstMemberId =
                await fetchFirstMemberId(widget.conversationId, idUser);
            print('Người tương tác: $firstMemberId');

            final recipientId = await getSocketId(firstMemberId);
            print('ID Socket Người tương tác: $recipientId');
          }
        }
      });

      // Lắng nghe sự kiện lỗi
      socket.on('connect_error', (error) {
        print('Connection error: $error');
      });

      // Lắng nghe sự kiện disconnect
      socket.on('disconnect', (_) {
        print('Disconnected from server');
      });
    } catch (e) {
      print('Error connecting to server: $e');
    }
  }

  void sendMessageSocket(String recipientId, String text, String createdAt,
      String id, String sender, String conversationId) {
    if (recipientId.trim() != '' &&
        text.trim() != '' &&
        createdAt.trim() != '' &&
        id.trim() != '' &&
        sender.trim() != '' &&
        conversationId.trim() != '') {
      // Kết nối với server
      socket = io.io(BASE_API, <String, dynamic>{
        'transports': ['websocket'],
      });

      // Gửi tin nhắn với thông tin người nhận
      socket.emit('message', {
        'recipientId': recipientId,
        'message': text,
        'createdAt': createdAt,
        '_id': id,
        'sender': sender,
        'conversationId': conversationId
      });

      print('gửi: $text -đến-: $recipientId');
    } else {
      print('Recipient ID and message cannot be empty.');
    }
  }

  @override
  void dispose() {
    // Lắng nghe sự kiện disconnect
    socket.on('disconnect', (_) {
      print('Disconnected from server');
    });
    // Disconnect socket when the screen is disposed
    socket.disconnect();
    messageController.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!socket.connected) {
      socket.connect();
    }
  }

  Future<void> _checkLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isLogin = prefs.getBool("isLogin");

    final String? idUser = prefs.getString("idUser");
    print('tai khoan dang nhap $idUser');

    if (mounted) {
      setState(() {
        userid = idUser ?? '';
      });
    }

    if (isLogin == null) {
      return;
    }

    if (isLogin) {
      // sử lý khi đã đăng nhập
    } else {
      // sử lý khi chưa đăng nhập
    }
  }

  Future<void> fetchMessages() async {
    print("fetchMessages được gọi");
    final response = await http
        .get(Uri.parse('$BASE_API/api/message/${widget.conversationId}'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      setState(() {
        messages = List<Message>.from(
            jsonData['data'].map((x) => Message.fromJson(x)));
        messages = messages.reversed.toList(); // Đảo ngược danh sách
        isLoading = false;
      });
    }
  }

  Future<void> createMessage(String text) async {
    if (text.isEmpty) {
      print("text rỗng rồi kìa");
      _textController.clear();

      return;
    } else {
      try {
        final message = {
          "conversationId": widget.conversationId,
          "sender": widget.userId,
          "text": text,
        };

        final response = await http.post(
          Uri.parse('$BASE_API/api/message/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(message),
        );

        if (response.statusCode == 200) {
          // print('Dữ liệu JSON thành công: ${response.body}');

          Map<String, dynamic> jsonMap = jsonDecode(response.body);
          Map<String, dynamic> data = jsonMap['data'];
//== lấy id current
          final recipientId = await idSocKetAdmin();
          print('ID Socket Người tương tác khi ấn gửi tin nhắn: $recipientId');
//== lấy id current
          print('_____--Data_____--: $data');

          String sender = data['sender'];
          String conversationId = data['conversationId'];
          String createdAt = data['createdAt'];
          String text = data['text'];
          String id = data['_id'];

          Message newMessage = Message(
            id: id,
            conversationId: conversationId,
            sender: sender,
            text: text,
            createdAt: createdAt,
          );
          if (mounted) {
            setState(() {
              messages.insert(0, newMessage);
            });
          }

          sendMessageSocket(
              recipientId!, text, createdAt, id, sender, conversationId);

          _textController.clear();
        } else {
          throw Exception('Failed to send message.');
        }
      } catch (e) {
        print('Error : $e');
      }
    }
  }

  Future<String?> idSocKetAdmin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? idUser = prefs.getString("idUser");

    final String firstMemberId =
        await fetchFirstMemberId(widget.conversationId, idUser!);
    // print('Người tương tác khi ấn gửi tin nhắn: $firstMemberId');

    final recipientId = await getSocketId(firstMemberId);
    // print('ID Socket Người tương tác khi ấn gửi tin nhắn: $recipientId');
    return recipientId;
  }

  String formatCreatedAt(String createdAt) {
    try {
      initializeDateFormatting();
      DateTime dateTime = DateTime.parse(createdAt).toUtc();
      dateTime = dateTime.add(
          const Duration(hours: 7)); // Thêm 7 giờ để chuyển từ UTC sang ICT
      final DateFormat formatter = DateFormat('HH:mm - dd/MM/yyyy', 'vi_VN');
      final String formatted = formatter.format(dateTime);
      return formatted;
      // ...
    } catch (e) {
      print('Invalid date format: $createdAt');
      return 'Lỗi ngày';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _controller,
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                // messages = messages.reversed.toList();

                final message = messages[index];
                final isMe = message.sender == widget.userId;

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: _displayMessage(message.text),
                        ),
                        Text(
                          formatCreatedAt(message.createdAt),
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Color.fromARGB(255, 85, 85, 85),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        messageText = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () async {
                    _pickImage();
                    // _controller.jumpTo(_controller.position.minScrollExtent);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 68, 161, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('Ảnh'),
                ),
                const SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () async {
                    createMessage(messageText);
                    _textController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 68, 161, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('Gửi'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String> fetchFirstMemberId(
      String conversationId, String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_API/api/conversation/r/$conversationId/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String firstMemberId = data['data']['members'][0];
        return firstMemberId;
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching conversation: $error');
      rethrow;
    }
  }

  Widget _displayMessage(String message) {
    final bool isImage = message.startsWith('/imgMessage/');

    if (isImage) {
      final String imageUrl = 'https://adadas.onrender.com$message';
      return SizedBox(
        width: 250,
        height: 250,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10), // Bo tròn các góc
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context , Object error, StackTrace? stackTrace){
              return const Icon(Icons.image);
            }
          ),
        ),
      );
    } else {
      return Text(message);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _uploadImage(File(image.path));
    } else {
      print('No image selected.');
    }
  }

  Future<void> _uploadImage(File image) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$BASE_API/api/message'));
    request.fields['conversationId'] = widget.conversationId;
    request.fields['sender'] = widget.userId;

    request.files.add(await http.MultipartFile.fromPath('text', image.path));

    var res = await request.send();

    if (res.statusCode == 200) {
      print("Image uploaded successfully");

      var responseData = await res.stream.transform(utf8.decoder).join();

      Map<String, dynamic> decodedData = json.decode(responseData);
      Map<String, dynamic> data = decodedData['data'];

      String sender = data['sender'];
      String conversationId = data['conversationId'];
      String createdAt = data['createdAt'];
      String text = data['text'];
      String id = data['_id'];

      Message newMessage = Message(
        id: id,
        conversationId: conversationId,
        sender: sender,
        text: text,
        createdAt: createdAt,
      );
      if (mounted) {
        setState(() {
          messages.insert(0, newMessage);
        });
      }

      //== lấy id current
      final recipientId = await idSocKetAdmin();
      print('ID Socket Người tương tác khi ấn gửi tin nhắn: $recipientId');
      //== lấy id current
      sendMessageSocket(
          recipientId!, text, createdAt, id, sender, conversationId);

      // print("dữ liệu link ảnh body tin nhắn: $responseData");
    } else {
      print("Upload failed. Status code: ${res.statusCode}");
    }
  }

  Future<void> setSocketId(String userId, String socketId) async {
    final String apiUrl = "$BASE_API/api/user/$userId";

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"socketId": socketId}),
      );

      if (response.statusCode == 200) {
        print("Thiết lập socket ID thành công : $socketId");
      } else {
        print("Thiết lập socket ID thất bại - ${response.statusCode}");
      }
    } catch (error) {
      print("Lỗi khi gửi yêu cầu: $error");
    }
  }

  Future<String?> getSocketId(String userId) async {
    final String apiUrl = "$BASE_API/api/userSocketId/$userId";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['socketId'];
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (error) {
      print("Error: $error");
      return null;
    }
  }

  final TextEditingController _textController = TextEditingController();
  String messageText = '';
}
