import 'package:flutter/material.dart';
import 'models.dart';
import 'product_detail_screen.dart';

class MenuScreen extends StatelessWidget {
  final List<Product> products;
  final Function(BuildContext) showFilterDialog;
  final TextEditingController searchController; 

  const MenuScreen({
    super.key,
    required this.products,
    required this.showFilterDialog,
    required this.searchController, 
  });

  Map<String, List<Product>> _groupProductsByCategory(List<Product> products) {
    final Map<String, List<Product>> grouped = {};

    for (var product in products) {
      if (!grouped.containsKey(product.category)) {
        grouped[product.category] = [];
      }
      grouped[product.category]!.add(product);
    }
    grouped.removeWhere((key, value) => value.isEmpty);
    return grouped;
  }
  
  Widget _imageErrorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
    return Container(
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: const Text('Image Error', style: TextStyle(color: Colors.grey, fontSize: 10)),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)),
        );
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 15, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(product.imagePath, height: 130, width: double.infinity, fit: BoxFit.cover, errorBuilder: _imageErrorBuilder), 
            ),
            Padding(
              padding: const EdgeInsets.all(10), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name, 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), 
                    maxLines: 1, 
                    overflow: TextOverflow.ellipsis
                  ),
                  const SizedBox(height: 6),
                  Text('${product.weight} | ${product.calories.toStringAsFixed(0)} ккал', style: const TextStyle(fontSize: 12, color: Colors.grey)), 
                  const SizedBox(height: 10), 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 16)), 
                      SizedBox(
                        height: 35, 
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${product.name} заказға қосылды!')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Заказать', style: TextStyle(fontSize: 13, color: Colors.white)), 
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBarAndFilter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Поиск...', 
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onPressed: () => showFilterDialog(context),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupedProducts = _groupProductsByCategory(products);
    final categories = groupedProducts.keys.toList();

    return Scaffold(
      backgroundColor: kBackgroundColor,
      
      body: Column(
        children: [
          _buildSearchBarAndFilter(context), 
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: groupedProducts.isEmpty
                    ? [const Center(child: Text('Өнімдер табылмады', style: TextStyle(fontSize: 18, color: Colors.grey)))]
                    : categories.map((categoryName) {
                        final productsInCategory = groupedProducts[categoryName]!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                              child: Text(
                                categoryName,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), 
                              ),
                            ),
                            SizedBox(
                              height: 280, 
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                itemCount: productsInCategory.length,
                                itemBuilder: (context, index) {
                                  return _buildProductCard(context, productsInCategory[index]);
                                },
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                        );
                      }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}