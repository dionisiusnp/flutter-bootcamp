import 'dart:io';

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

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;
    try {
      await chatApi.createChat(userId: userId!, message: message.trim());
      setState(() {
        _chats = _fetchChats();
      });
      _messageController.clear();
      _chats.then((_) => _scrollToBottom());
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengirim pesan: $error")),
      );
    }
  }

  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
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
                builder: (BuildContext context, AsyncSnapshot<List<Chat>> snapshot) {
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

  Widget _buildChatList(List<Chat> chats) {
  return ListView.builder(
    controller: _scrollController,
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    itemCount: chats.length,
    itemBuilder: (context, index) {
      Chat chat = chats[index];
      bool isMe = chat.isSellerReply ?? false;
      return Align(
        alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isMe ? Colors.blue.shade100 : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            chat.message ?? '',
            style: TextStyle(
              color: isMe ? Colors.black : Colors.black87,
            ),
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
