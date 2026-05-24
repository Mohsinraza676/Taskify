import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/task_card.dart';
import '../widgets/empty_state_widget.dart';
import 'add_task_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _filter = 'All';

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning 👋';
    if (hour < 17) return 'Good afternoon 👋';
    return 'Good evening 👋';
  }

  void _openAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTaskScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayName = DateFormat('EEEE').format(now);
    final dateStr = DateFormat('MMMM d, y').format(now);
    final timeStr = DateFormat('hh:mm a').format(now);

    final tasksAsync = ref.watch(tasksStreamProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded( // Fixed header overflow
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getGreeting(),
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 24, // Slightly smaller to prevent overflow
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$dayName, $dateStr",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      timeStr,
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      title: 'Pending',
                      count: ref.watch(pendingTasksCountProvider),
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _SummaryCard(
                      title: 'Completed',
                      count: ref.watch(completedTasksCountProvider),
                      color: AppTheme.successGreen,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Tasks',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  // Use a constrained box or just the chip row
                ],
              ),
            ),
            
            // Fixed Filter row overflow with horizontal scroll
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildFilterChips(),
            ),

            Expanded(
              child: tasksAsync.when(
                data: (tasks) {
                  final filteredTasks = tasks.where((task) {
                    if (_filter == 'Pending') return !task.isCompleted;
                    if (_filter == 'Completed') return task.isCompleted;
                    return true;
                  }).toList();

                  if (tasks.isEmpty) {
                    return const EmptyStateWidget();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return TaskCard(
                        key: ValueKey(task.id),
                        task: task,
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddTaskSheet,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Task'),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Row(
      children: ['All', 'Pending', 'Completed'].map((filter) {
        final isSelected = _filter == filter;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChoiceChip(
            label: Text(
              filter,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : AppTheme.subtitleText,
              ),
            ),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) setState(() => _filter = filter);
            },
            selectedColor: AppTheme.primaryColor,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            side: BorderSide.none,
            showCheckmark: false,
          ),
        );
      }).toList(),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppTheme.softShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.subtitleText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              '$count',
              key: ValueKey(count),
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
