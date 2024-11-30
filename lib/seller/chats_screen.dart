import 'package:flutter/material.dart';
import 'package:marketplace_apps/api/chat_api.dart';
import 'package:marketplace_apps/buyer/chat_room_screen.dart';
import 'package:marketplace_apps/model/chat_model.dart';

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late ChatApi chatApi;
  late Future<List<Chat>> futureChats;

  @override
  void initState() {
    super.initState();
    chatApi = ChatApi();
    futureChats = chatApi.getChatsSeller();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Chat"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Chat>>(
        future: futureChats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Tidak ada chat."));
          }

          List<Chat> chats = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              Chat chat = chats[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      chat.user_id?.toString() ?? "-",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  title: Text(
                    chat.message ?? "Tidak ada pesan",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    chat.created_at?.toLocal().toString() ?? "-",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      if (chat.user_id != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatRoomScreen(),
                          ),
                        );
                      }
                    },
                    child: Text("Balas Pesan"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
