import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace_apps/api/chat_api.dart';
import 'package:marketplace_apps/model/chat_model.dart';

class RoomChatScreen extends StatefulWidget {
  final int? userId;
  final String? userName;

  const RoomChatScreen({Key? key, this.userId, this.userName}) : super(key: key);

  @override
  _RoomChatScreenState createState() => _RoomChatScreenState();
}

class _RoomChatScreenState extends State<RoomChatScreen> {
  late ChatApi chatApi;
  late Future<List<Chat>> _chats;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    chatApi = ChatApi();
    _chats = _fetchChats();
  }

  Future<List<Chat>> _fetchChats() async {
    return await chatApi.getChatsBuyer(widget.userId!);
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
        userId: widget.userId!,
        message: message.trim(),
        isSellerReply: true,
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

      List<String>? mediaUrls = chat.mediaUrls;

      return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isMe ? Colors.blue.shade100 : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (chat.message != null && chat.message!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      chat.message!,
                      style: TextStyle(
                        color: isMe ? Colors.black : Colors.black87,
                      ),
                    ),
                  ),
                if (mediaUrls != null && mediaUrls.isNotEmpty)
                ...mediaUrls.map(
                  (url) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          _showFullScreenImage(context, url);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                  size: 50,
                                ),
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          child: Stack(
            children: [
              Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                    size: 50,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
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
