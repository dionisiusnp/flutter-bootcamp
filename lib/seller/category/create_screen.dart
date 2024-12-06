import 'package:flutter/material.dart';
import 'package:marketplace_apps/api/product_category_api.dart'; // Pastikan Anda punya API untuk kategori
import 'package:marketplace_apps/model/product_category_model.dart'; // Model untuk kategori

class CreateCategoryScreen extends StatefulWidget {
  final ProductCategory? category; // Menambahkan parameter kategori untuk edit

  CreateCategoryScreen({Key? key, this.category}) : super(key: key);

  @override
  _CreateCategoryScreenState createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _categoryNameController = TextEditingController();

  bool _isLoading = false;
  bool _isFieldCategoryValid = false;

  late ProductCategoryApi _categoryApi;

  @override
  void initState() {
    super.initState();
    _categoryApi = ProductCategoryApi();

    // Jika ada kategori yang dipilih untuk diedit, set controller dengan nama kategori tersebut
    if (widget.category != null) {
      _categoryNameController.text = widget.category!.name ?? ''; 
    }
  }

  // Fungsi untuk mengirim data kategori (create atau update)
  Future<void> _submitCategory() async {
    if (!_isFieldCategoryValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a category name")),
      );
      return;
    }

    setState(() => _isLoading = true);

    ProductCategory category = ProductCategory(
      id: widget.category?.id,  // Jika ada kategori yang diedit, masukkan ID
      icon: 'null', 
      name: _categoryNameController.text,
    );

    bool success;
    if (widget.category == null) {
      success = await _categoryApi.createProductCategory(category);  // Create kategori baru
    } else {
      success = await _categoryApi.updateProductCategory(category);  // Update kategori yang ada
    }

    setState(() => _isLoading = false);

    // Menampilkan dialog berdasarkan status pengiriman
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(success ? 'Success' : 'Error'),
        content: Text(
          success
              ? (widget.category == null ? 'Category has been successfully added!' : 'Category has been successfully updated!')
              : 'Failed to process category. Please try again later.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Close the dialog
              if (success) {
                Navigator.pop(context, true); // Mengirim nilai true untuk memberi tahu berhasil
              } else {
                Navigator.pop(context); // Jika gagal tetap kembali
              }
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
          widget.category == null ? 'Add Category' : 'Edit Category',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Name *',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _categoryNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter category name',
              ),
              onChanged: (value) {
                setState(() {
                  _isFieldCategoryValid = value.trim().isNotEmpty;
                });
              },
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: _isLoading ? null : _submitCategory,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Icon(Icons.check),
              ),
            )
          ],
        ),
      ),
    );
  }
}
