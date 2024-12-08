import 'package:flutter/material.dart';
import 'package:marketplace_apps/api/chat_api.dart';
import 'package:marketplace_apps/model/chat_model.dart';
import 'package:marketplace_apps/seller/chat/room_chat_screen.dart';
import 'package:marketplace_apps/util/auth.dart';

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

  Future<void> _logout() async {
    final bool confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Apakah Anda yakin ingin logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );

    if (confirm) {
      await Auth.logout(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Chat"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: "Logout",
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<Chat>?>(
          future: chatApi.getChatsSeller(),
          builder: (BuildContext context, AsyncSnapshot<List<Chat>?> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<Chat>? chats = snapshot.data;
              if (chats == null || chats.isEmpty) {
                return const Center(
                  child: Text("Tidak ada data chat."),
                );
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
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        Chat chat = chats[index];
        return ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey.shade300,
            child: Text(
              chat.user?.name?.substring(0, 1).toUpperCase() ?? "?",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            chat.user?.name ?? "Tidak ada nama",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                chat.latestMessage ?? "Tanpa pesan",
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                "${chat.latestMessageTime ?? "Tidak diketahui"}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          trailing: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoomChatScreen(
                    userId: chat.userId,
                    userName: chat.user?.name ?? "Pembeli",
                  ),
                ),
              ).then((_) {
                setState(() {}); // Memuat ulang layar setelah kembali
              });
            },
            label: const Text("Balas Pesan"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(80, 36),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 1, thickness: 1),
    );
  }
}
