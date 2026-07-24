import 'package:flutter/material.dart';
import 'package:rocket_slice/features/home/services/pizza_provider.dart';

class CategoriesSelector extends StatelessWidget {
  const CategoriesSelector({super.key, required this.pizzaProvider});

  final PizzaProvider pizzaProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Categories',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: pizzaProvider.categories.length,
            itemBuilder: (context, index) {
              final category = pizzaProvider.categories[index];
              final isSelected = category == pizzaProvider.selectedCategory;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      pizzaProvider.selectCategory(category);
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
