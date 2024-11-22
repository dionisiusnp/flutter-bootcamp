import 'package:flutter/material.dart';
import 'package:marketplace_apps/seller/create_product_screen.dart';

class ProductScreen extends StatefulWidget {
  ProductScreen({Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _allProducts = [
    {"name": "Produk 1", "description": "Short Description", "price": 5000000, "is_available": true},
    {"name": "Produk 2", "description": "Short Description", "price": 5000000, "is_available": true},
    {"name": "Produk 3", "description": "Short Description", "price": 5000000, "is_available": true},
    {"name": "Produk 4", "description": "Short Description", "price": 5000000, "is_available": true},
    {"name": "Produk 5", "description": "Short Description", "price": 5000000, "is_available": true},
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.shopping_cart, color: Colors.black),
            SizedBox(width: 8),
            Text(
              'Produk',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search, color: Colors.black),
            ),
          ],
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: 'harga',
                  items: ['harga', 'nama', 'populer']
                      .map((value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (value) {},
                ),
                Spacer(),
                Text(
                  '102.220 barang ditemukan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Jumlah kolom
                  mainAxisSpacing: 16, // Jarak vertikal antar item
                  crossAxisSpacing: 16, // Jarak horizontal antar item
                  childAspectRatio: 2 / 2.5, // Rasio ukuran item
                ),
                itemCount: _allProducts.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(_allProducts[index]);
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: Icon(Icons.home), onPressed: () {}),
            IconButton(icon: Icon(Icons.chat), onPressed: () {}),
            SizedBox(width: 48), // Space for the FAB
            IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
            IconButton(icon: Icon(Icons.account_circle), onPressed: () {}),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => CreateProductScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                color: Colors.grey[300],
                child: Center(
                  child: Image.asset(
                	'images/produk-digital.jpeg', // Gunakan asset untuk gambar produk
                	fit: BoxFit.cover,
               		width: double.infinity,
              	  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Rp ${product["price"].toString()}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              product["description"],
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
