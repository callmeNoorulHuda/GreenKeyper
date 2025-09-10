// lib/screens/checklist_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenkeyper/ui/screens/dashboard/submission_screen.dart';

import '../../../viewmodels/providers/checklist_provider.dart';
import '../../widgets/common/custom_button.dart';

class ChecklistScreen extends ConsumerStatefulWidget {
  const ChecklistScreen({super.key});

  @override
  ConsumerState<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends ConsumerState<ChecklistScreen> {
  Widget _buildProgressBar(int completedItems, int totalItems) {
    return Container(
      width: double.infinity,
      height: 6,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(3),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: completedItems / totalItems,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF006666),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFaultDialog(int itemId, String itemTitle, bool currentFlagStatus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Flag as Fault'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Item: $itemTitle',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                currentFlagStatus
                    ? 'This item is currently flagged as a fault. Do you want to remove the fault flag?'
                    : 'Do you want to flag this item as a fault?',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(checklistProvider.notifier).toggleFlag(itemId);
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      currentFlagStatus
                          ? 'Fault flag removed'
                          : 'Item flagged as fault',
                    ),
                    backgroundColor:
                        currentFlagStatus ? Colors.green : Colors.orange,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    currentFlagStatus ? Colors.green : Colors.orange,
              ),
              child: Text(
                currentFlagStatus ? 'Remove Flag' : 'Flag as Fault',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final checklist = ref.watch(checklistProvider);

    // Calculate completion status
    final completedItems =
        checklist.items.where((item) => item.isCompleted).length;
    final totalItems = checklist.items.length;
    final allCompleted = completedItems == totalItems;
    final flaggedItems = checklist.items.where((item) => item.isFlagged).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF057B99),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Image.asset(
              "assets/checklist_icon.png",
              height: 35,
              width: 35,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.checklist,
                    color: Colors.white,
                    size: 20,
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            const Text(
              'Checklist',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              "(${checklist.items.length})",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        actions: [
          if (flaggedItems > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.flag,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      flaggedItems.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          // Progress indicator at top
          Container(
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            color: const Color(0xFFF5F5F5),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: _buildProgressBar(completedItems, totalItems)),
                    const SizedBox(width: 10),
                    Text(
                      '${(completedItems / totalItems * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Checklist items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 12, right: 12),
              itemCount: checklist.items.length,
              itemBuilder: (context, index) {
                final item = checklist.items[index];
                return Container(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.only(left: 7, right: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Column with line + circle
                      Column(
                        children: [
                          // Circle
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                                color: item.isCompleted
                                    ? const Color(0xFF006666)
                                    : const Color(0xFFF5F5F5),
                                shape: BoxShape.circle,
                                border: Border.all(width: 0.1)),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: item.isCompleted
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),

                          // Bottom line (hidden for last item)
                          if (index != checklist.items.length - 1)
                            Container(
                              width: 0.8,
                              height: 40,
                              color: Colors.grey,
                            ),
                        ],
                      ),

                      const SizedBox(width: 12),

                      // Task text
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: item.isFlagged ? 8 : 0,
                          ),
                          decoration: item.isFlagged
                              ? BoxDecoration(
                                  color: Colors.orange.withAlpha(25),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.orange.withAlpha(77),
                                    width: 1,
                                  ),
                                )
                              : null,
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 14,
                              color: item.isFlagged
                                  ? Colors.orange[800]
                                  : Colors.black87,
                              height: 1.4,
                              fontWeight: item.isFlagged
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Checkbox
                      GestureDetector(
                        onTap: () {
                          ref
                              .read(checklistProvider.notifier)
                              .toggleItem(item.id);
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: item.isCompleted
                              ? const Icon(
                                  Icons.check,
                                  color: Color(0xFF017F7F),
                                  size: 18,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Flag Icon
                      GestureDetector(
                        onTap: () => _showFaultDialog(
                          item.id,
                          item.title,
                          item.isFlagged,
                        ),
                        child: Icon(
                          Icons.flag_sharp,
                          color:
                              item.isFlagged ? Colors.orange : Colors.grey[400],
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Next button - only enabled when all items are completed
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: CustomButton(
                text: 'Next',
                textColor:
                    allCompleted ? Colors.white : const Color(0xFFA9A9A9),
                onPressed: allCompleted
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SubmissionScreen(),
                          ),
                        );
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please complete the ${totalItems - completedItems} remaining tasks',
                              style: const TextStyle(color: Colors.white),
                            ),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                width: double.infinity,
                height: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
