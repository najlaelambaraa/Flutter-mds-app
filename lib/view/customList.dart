import 'package:flutter/material.dart';

class CustomList extends StatelessWidget {
  final List<Map<String, String>> items;
  final Function(String) onTap;
  final Function(int) onDelete;
  final String? imageUrlKey;
  final String titleKey;
  final bool showImage;

  CustomList({
    required this.items,
    required this.onTap,
    required this.onDelete,
    this.imageUrlKey,
    required this.titleKey,
    this.showImage = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final imageUrl = items[index][imageUrlKey] ?? '';
        return Dismissible(
          key: Key(items[index][titleKey]!),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            onDelete(index);
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: GestureDetector(
              onTap: () => onTap(items[index][titleKey]!),
              child: Row(
                children: [
                  if (showImage && imageUrlKey != null && imageUrl.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: imageUrl.startsWith('http')
                          ? Image.network(
                              imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error, color: Colors.red);
                              },
                            )
                          : Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey,
                              child: Icon(Icons.image, color: Colors.white),
                            ),
                    ),
                  if (showImage && imageUrlKey != null && imageUrl.isNotEmpty)
                    SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items[index][titleKey]!,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward, color: Color(0xFF212E53)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
