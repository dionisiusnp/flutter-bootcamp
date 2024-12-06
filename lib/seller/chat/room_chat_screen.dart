import 'package:flutter/material.dart';
import 'package:marketplace_apps/api/chat_api.dart';
import 'package:marketplace_apps/model/chat_model.dart';

class RoomChatScreen extends StatefulWidget {
  final int? userId;

  const RoomChatScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _RoomChatScreenState createState() => _RoomChatScreenState();
}

class _RoomChatScreenState extends State<RoomChatScreen> {
  late ChatApi chatApi;
  late Future<List<Chat>> _chats;

  @override
  void initState() {
    super.initState();
    chatApi = ChatApi();
    _chats = _fetchChats();
  }

  Future<List<Chat>> _fetchChats() async {
    // Gunakan endpoint dan filter berdasarkan userId
    return await chatApi.getChatsBuyer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat dengan User ${widget.userId}"),
      ),
      body: SafeArea(
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
    );
  }

  Widget _buildChatList(List<Chat> chats) {
    // Filter pesan berdasarkan userId
    List<Chat> userChats = chats.where((chat) => chat.userId == widget.userId).toList();

    return ListView.builder(
      itemCount: userChats.length,
      itemBuilder: (context, index) {
        Chat chat = userChats[index];
        return ListTile(
          title: Text(chat.message ?? ''),
          // subtitle: Text(chat.createdAt ?? ''),
        );
      },
    );
  }
}