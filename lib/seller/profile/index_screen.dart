import 'package:flutter/material.dart';
import 'package:marketplace_apps/api/user_api.dart';
import 'package:marketplace_apps/model/user_model.dart';
import 'package:marketplace_apps/util/auth.dart';

class IndexProfileScreeen extends StatefulWidget {
  @override
  _IndexCategoryState createState() => _IndexCategoryState();
}

class _IndexCategoryState extends State<IndexProfileScreeen> {
  late UserApi userApi;
  late Future<User?> futureUser;

  @override
  void initState() {
    super.initState();
    userApi = new UserApi();
    futureUser = UserApi().getUser();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<User?>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('User not found.'));
          } else {
            // Data tersedia
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('images/profile.jpg'), // Ganti dengan path gambar profil Anda
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: user.name),
                    decoration: InputDecoration(
                      labelText: "Nama",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: user.email),
                    decoration: InputDecoration(
                      labelText: "E-Mail",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: user.address ?? ""),
                    decoration: InputDecoration(
                      labelText: "Alamat",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

}