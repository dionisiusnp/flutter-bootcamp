import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Icon(Icons.shopping_basket),
            SizedBox(width: 8),
            Text('Produk'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Search functionality
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Cari produk...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Icon(Icons.search),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: Icon(Icons.sort),
                  label: Text('Harga'),
                  onPressed: () {
                    // Sorting functionality
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('102.220 barang ditemukan', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 6, // Replace with the length of your product list
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.grey[300], // Placeholder for image
                            child: Center(child: Text('Image')),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rp 5.000.000',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('2022'),
                              Text('Short Description'),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: Icon(Icons.shopping_cart),
                                  onPressed: () {
                                    // Add to cart functionality
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
