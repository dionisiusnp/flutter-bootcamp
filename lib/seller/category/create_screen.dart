import 'package:flutter/material.dart';

class CreateCategoryScreen extends StatefulWidget {
  @override
  _CreateCategoryScreenState createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _categoryNameController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submit() async {
    // Pastikan form sudah valid sebelum mengirim request
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Category has been successfully added!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Close the dialog
                Navigator.pop(context); // Go back to the previous screen
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: Text(
          'Add Category',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                // Handle upload logo functionality
              },
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload, size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        'Upload Logo',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      Text(
                        '30x30 Recommend',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Category name *',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter category name',
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: _submit,
                child: Icon(Icons.check),
              ),
            )
          ],
        ),
      ),
    );
  }
}
