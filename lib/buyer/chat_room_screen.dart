import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace_apps/api/chat_api.dart';
import 'package:marketplace_apps/model/chat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoomScreen extends StatefulWidget {
  final String userName;

  const ChatRoomScreen({Key? key, this.userName = 'Admin'}) : super(key: key);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  late ChatApi chatApi;
  late Future<List<Chat>> _chats;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int? userId;

  @override
  void initState() {
    super.initState();
    chatApi = ChatApi();
    _chats = _fetchChats();
    _initializeUserId();
  }

  Future<void> _initializeUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');
    setState(() {
      userId = id;
      _chats = _fetchChats();
    });
  }

  Future<List<Chat>> _fetchChats() async {
    if (userId == null) return [];
    return await chatApi.getChatsBuyer(userId!);
  }

  XFile? _imageXFile; // Untuk General Handling
  File? _imageFile; // Untuk Android/iOS
  Uint8List? _imageBytes; // Untuk Browser

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        _imageXFile = pickedFile;
        _imageBytes = await pickedFile.readAsBytes();
      } else {
        _imageFile = File(pickedFile.path);
      }

      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;
    try {
      Uint8List? fileBytes;
      String? fileName;

      if (kIsWeb && _imageBytes != null) {
        fileBytes = _imageBytes; // Browser menggunakan byte array
        fileName = _imageXFile?.name;
      } else if (_imageFile != null) {
        fileBytes = await _imageFile!.readAsBytes(); // Android/iOS gunakan File
        fileName = _imageFile!.path.split('/').last;
      }

      await chatApi.createChat(
        userId: userId!,
        message: message.trim(),
        fileBytes: fileBytes,
        fileName: fileName,
      );
      setState(() {
        _chats = _fetchChats();
        _imageFile = null;
        _imageBytes = null;
      });
      _messageController.clear();
      _chats.then((_) => _scrollToBottom());
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengirim pesan: $error")),
      );
    }
  }

  void _scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName ?? "Room Chat"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Chat>>(
                future: _chats,
                builder:
                    (BuildContext context, AsyncSnapshot<List<Chat>> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error.toString()}"),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    List<Chat>? chats = snapshot.data;
                    if (chats == null || chats.isEmpty) {
                      return const Center(child: Text("Belum ada pesan."));
                    }
                    return _buildChatList(chats);
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            _buildMessageInputField(),
          ],
        ),
      ),
    );
  }

  // Widget _buildChatList(List<Chat> chats) {
  //   return ListView.builder(
  //     controller: _scrollController,
  //     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
  //     itemCount: chats.length,
  //     itemBuilder: (context, index) {
  //       Chat chat = chats[index];
  //       bool isMe = chat.isSellerReply ?? false;
  //       return Align(
  //         alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
  //         child: Container(
  //           margin: const EdgeInsets.symmetric(vertical: 5),
  //           padding: const EdgeInsets.all(12),
  //           decoration: BoxDecoration(
  //             color: isMe ? Colors.blue.shade100 : Colors.grey.shade300,
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Text(
  //             chat.message ?? '',
  //             style: TextStyle(
  //               color: isMe ? Colors.black : Colors.black87,
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildChatList(List<Chat> chats) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        Chat chat = chats[index];
        bool isMe = chat.isSellerReply ?? false;

        List<String>? mediaUrls = chat.mediaUrls;
        // List<String>? mediaUrls = chat.mediaUrls?.map((url) {
        //   return url.replaceFirst('localhost', '127.0.0.1');
        // }).toList();

        return Align(
          alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue.shade100 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                if (chat.message != null && chat.message!.isNotEmpty)
                  Text(
                    chat.message!,
                    style: TextStyle(
                      color: isMe ? Colors.black : Colors.black87,
                    ),
                  ),
                if (mediaUrls != null && mediaUrls.isNotEmpty)
                  ...mediaUrls.map(
                    (url) => Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.image, color: Colors.blue),
            onPressed: _pickImage,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "Ketik pesan...",
                border: InputBorder.none,
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (value) => _sendMessage(value),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () => _sendMessage(_messageController.text),
          ),
        ],
      ),
    );
  }
}
