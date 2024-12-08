import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;
    try {
      await chatApi.createChat(userId: widget.userId!, message: message.trim());
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
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
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
