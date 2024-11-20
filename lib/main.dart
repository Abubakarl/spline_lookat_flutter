import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter E-commerce',
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const ProductPage(),
    );
  }
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _quantity = 1;
  int _selectedColor = 0;
  String _selectedEdition = 'Standard Edition';
  InAppWebViewController? _webViewController;

  // Map each color to a corresponding image
  final Map<String, String> colorToImage = {
    "#0051dc":
        "https://my.spline.design/play5materials-e848ce57bdd9567f9ce8f508f1199c42/",
    "#00bac6":
        "https://my.spline.design/play5materialscopycopy-c43c67045395ed7dc3dc3d3a478ebe84/",
    "#bb00cd":
        "https://my.spline.design/play5materialscopy-9d512453329a620bee5c5b5fcfb74d2d/",
  };

  final List<String> colors = ["#0051dc", "#00bac6", "#bb00cd"];

  final List<String> editions = [
    'Standard Edition',
    'God of War Ragnarök',
    'Spider-Man 2',
    'Limited Edition',
  ];

  void _updateWebView() {
    if (_webViewController != null) {
      _webViewController!.loadUrl(
        urlRequest: URLRequest(
          url: WebUri.uri(Uri.parse(colorToImage[colors[_selectedColor]]!)),
        ),
      );
    }
  }

  Widget _buildImageGallery(BuildContext context, {bool isDesktop = false}) {
    return Container(
      height: isDesktop ? MediaQuery.of(context).size.height - 48 : 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InAppWebView(
        initialSettings: InAppWebViewSettings(
          transparentBackground: true,
        ),
        initialUrlRequest: URLRequest(
          url: WebUri.uri(Uri.parse(colorToImage[colors[_selectedColor]]!)),
        ),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildTag('Official PlayStation 5', Colors.grey.shade200),
                const SizedBox(width: 8),
                _buildTag('In Stock', Colors.green.shade100),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'DualSense™ Wireless Controller',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ...List.generate(
                    5,
                    (index) =>
                        const Icon(Icons.star, color: Colors.amber, size: 20)),
                const SizedBox(width: 8),
                Text(
                  '4.8 (2,584 reviews)',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              '\$69.99',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Color',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: colors.asMap().entries.map((entry) {
                final colorIndex = entry.key;
                final colorValue = entry.value;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = colorIndex;
                      _updateWebView(); // Update the WebView
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(
                          int.parse(colorValue.substring(1, 7), radix: 16) +
                              0xFF000000),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColor == colorIndex
                            ? Colors.red
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Edition',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: editions.map((edition) {
                return ChoiceChip(
                  label: Text(edition),
                  selected: _selectedEdition == edition,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedEdition = edition);
                    }
                  },
                  selectedColor: Colors.red.shade100,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text(
                  'Quantity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                _buildQuantitySelector(),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Add to Cart'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Buy Now',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => setState(() {
              if (_quantity > 1) _quantity--;
            }),
            icon: const Icon(Icons.remove),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '$_quantity',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _quantity++),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 1000) {
            // Desktop layout
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildImageGallery(context, isDesktop: true),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      flex: 2,
                      child: _buildProductDetails(context),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Mobile layout
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildImageGallery(context),
                  _buildProductDetails(context),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
