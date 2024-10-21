import 'package:flutter/material.dart';

import '../data/cat_data_manager.dart';

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({
    super.key,
    required this.context,
    required this.provider,
  });

  final BuildContext context;
  final CatDataManager provider;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 16),
          Semantics(
            label: 'Error description',
            child: Text(
              provider.errorMessage ?? 'An unknown error occurred',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.red),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            onPressed: () {
              // For cat_breeds.dart
              provider.reloadBreeds();
              // For cat_info.dart
              // provider.getCatSpecificData(widget.catId);
            },
          ),
        ],
      ),
    );
  }
}
