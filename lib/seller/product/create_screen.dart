import 'package:flutter/material.dart';
import 'package:marketplace_apps/api/product_api.dart';
import 'package:marketplace_apps/api/product_category_api.dart'; // Pastikan API sudah benar
import 'package:marketplace_apps/model/product_category_model.dart';
import 'package:marketplace_apps/model/product_model.dart'; // Pastikan model sudah benar

class CreateProductScreen extends StatefulWidget {
  final Product? product; // Menambahkan parameter kategori untuk edit

  CreateProductScreen({Key? key, this.product}) : super(key: key);

  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();

  String? _category;
  List<ProductCategory> _categories = []; // List kategori produk
  bool _isLoading = true; // Menunggu data kategori dimuat

  late ProductApi _productApi;

  @override
  void initState() {
    super.initState();
    _productApi = ProductApi();

    if (widget.product != null) {
      _productNameController.text = widget.product!.name ?? ''; 
      _productPriceController.text = widget.product!.price?.toString() ?? '';
      _productDescriptionController.text = widget.product!.description ?? '';
      _category = widget.product!.product_category_id?.toString(); 
    }


    _loadCategories(); // Memanggil fungsi untuk mengambil kategori produk dari API
  }

  // Fungsi untuk mengambil kategori dari API
  Future<void> _loadCategories() async {
    ProductCategoryApi productCategoryApi = ProductCategoryApi();
    List<ProductCategory> categories = await productCategoryApi.getProductCategory();
    setState(() {
      _categories = categories; // Menyimpan kategori yang diterima dari API
      _isLoading = false; // Data kategori sudah dimuat
    });
  }

  Future<void> _submitCategory() async {
    setState(() => _isLoading = true);


    int? price = int.tryParse(_productPriceController.text);

    Product product = Product(
      id: widget.product?.id,  // Jika ada kategori yang diedit, masukkan ID
      name: _productNameController.text,
      price: price,
      shipping_cost: 0,
      is_available: 1,
      description: _productDescriptionController.text,
      product_category_id: _category != null ? int.tryParse(_category!) : null,
    );

    bool success;
    if (widget.product == null) {
      success = await _productApi.createProduct(product);  // Create kategori baru
    } else {
      success = await _productApi.updateProduct(product);  // Update kategori yang ada
    }

    setState(() => _isLoading = false);

    // Menampilkan dialog berdasarkan status pengiriman
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(success ? 'Success' : 'Error'),
        content: Text(
          success
              ? (widget.product == null ? 'Product has been successfully added!' : 'Product has been successfully updated!')
              : 'Failed to process product. Please try again later.',
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Add Product',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hapus bagian upload gambar
              SizedBox(height: 16),
              Text(
                'Product name *',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter product name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price *',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _productPriceController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter price',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter price';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Description',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _productDescriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Write about your product...',
                ),
                maxLines: 4,
              ),
              SizedBox(height: 16),
              Text(
                'Choose Category *',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<int>(
                      value: _category != null ? int.tryParse(_category!) : null, // Pastikan tipe data cocok
                      items: _categories
                          .map((category) => DropdownMenuItem<int>(
                                value: category.id, // Menggunakan ID kategori sebagai value
                                child: Text(category.name ?? 'Unknown'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _category = value?.toString(); // Simpan ID kategori dalam bentuk string
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Please choose a category';
                        }
                        return null;
                      },
                    ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _submitCategory();
                    }
                  },
                  child: Text('Save Product'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
