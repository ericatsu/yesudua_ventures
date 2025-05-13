import 'package:flutter/material.dart';

class ImageSelector extends StatelessWidget {
  final String? selected;
  final Function(String) onSelected;

  const ImageSelector({super.key, this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    const imageKeys = ['wood', 'cement', 'rods', 'paint'];

    return Wrap(
      spacing: 8,
      children:
          imageKeys.map((key) {
            final isSelected = key == selected;
            return GestureDetector(
              onTap: () => onSelected(key),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.image,
                      color: isSelected ? Colors.blue : Colors.grey,
                    ),
                    Text(key),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}