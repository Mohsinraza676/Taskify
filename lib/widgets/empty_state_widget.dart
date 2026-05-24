import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.task_alt,
                size: 100,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No tasks yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.darkText,
                    fontSize: 24,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tap the + button to add your first task',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
