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
  String? _imageName;

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
        _imageName = pickedFile.name;
      });
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;
    try {
      Uint8List? fileBytes;
      String? fileName;

      if (kIsWeb && _imageBytes != null) {
        fileBytes = _imageBytes;
        fileName = _imageXFile?.name;
      } else if (_imageFile != null) {
        fileBytes = await _imageFile!.readAsBytes();
        fileName = _imageFile!.path.split('/').last;
      }

      await chatApi.createChat(
        userId: userId!,
        message: message.trim(),
        isSellerReply: false,
        fileBytes: fileBytes,
        fileName: fileName,
      );
      setState(() {
        _chats = _fetchChats();
        _imageFile = null;
        _imageBytes = null;
        _imageName = null;
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
          alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe ? Colors.grey.shade300 : Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                if (chat.message != null && chat.message!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      chat.message!,
                      style: TextStyle(
                        color: isMe ? Colors.black87 : Colors.black,
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
      child: Column(
        children: [
          if (_imageName != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: kIsWeb ? MemoryImage(_imageBytes!) : FileImage(_imageFile!),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _imageFile = null;
                        _imageBytes = null;
                        _imageName = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
          Row(
            children: [
              if (_imageName == null)
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
        ],
      ),
    );
  }
}
