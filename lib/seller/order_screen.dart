import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final List<Map<String, dynamic>> _allOrders = [
    {"created_at": "22 November 2024", "buyer": "Dionisius", "total": 100000,  "status": "Process"},
    {"created_at": "22 November 2024", "buyer": "Nanda", "total": 150000, "status": "Paid"},
    {"created_at": "22 November 2024", "buyer": "Dionisius", "total": 100000,  "status": "Process"},
    {"created_at": "22 November 2024", "buyer": "Nanda", "total": 150000, "status": "Paid"},
    {"created_at": "22 November 2024", "buyer": "Dionisius", "total": 100000,  "status": "Process"},
    {"created_at": "22 November 2024", "buyer": "Nanda", "total": 150000, "status": "Paid"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Pesanan'),
      ),
      body: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 2 / 2.5,
                ),
                itemBuilder: (context, index) {
                  return _buildOrderCard(_allOrders[index]);
                },
              ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expanded(
            //   child: Image.asset(
            //     'assets/images/logos.png',
            //     fit: BoxFit.cover,
            //     width: double.infinity,
            //   ),
            // ),
            // SizedBox(height: 8),
            Text(
              order["buyer"],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            // SizedBox(height: 4),
            Text(
              'Kategori: ${order["status"]}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            // SizedBox(height: 4),
            Text(
              'Harga: Rp. ${order["total"]}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            // SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
