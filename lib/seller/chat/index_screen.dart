import 'package:flutter/material.dart';
import 'package:marketplace_apps/api/chat_api.dart';
import 'package:marketplace_apps/model/chat_model.dart';
import 'package:marketplace_apps/seller/chat/room_chat_screen.dart';

class IndexChatScreen extends StatefulWidget {
  @override
  _IndexChatScreenState createState() => _IndexChatScreenState();
}

class _IndexChatScreenState extends State<IndexChatScreen> {
  late ChatApi chatApi;

  @override
  void initState() {
    super.initState();
    chatApi = ChatApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Chat"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Chat>?>(
          future: chatApi.getChatsSeller(),
          builder: (BuildContext context, AsyncSnapshot<List<Chat>?> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Something went wrong: ${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<Chat>? chats = snapshot.data;
              if (chats == null || chats.isEmpty) {
                return Center(child: Text("Tidak ada data Chat."));
              }
              return _buildListView(chats);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildListView(List<Chat> chats) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          Chat chat = chats[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      chat.user?.name ?? 'Tidak ada nama',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      chat.latestMessage ?? 'Tanpa Pesan',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Terakhir: ${chat.latestMessageTime ?? 'Tidak diketahui'}",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RoomChatScreen(userId: chat.userId),
                              ),
                            ).then((value) {
                              setState(() {}); // Memuat ulang layar setelah kembali
                            });
                          },
                          icon: Icon(Icons.message),
                          label: Text("Lihat"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}