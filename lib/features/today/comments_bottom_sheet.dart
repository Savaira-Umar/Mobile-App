import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/models/dummy_data.dart';

/// Task Comments modal bottom sheet (S10):
/// - List of comments with author & timestamp
/// - Author can edit/delete their own comments
/// - Send new comment input bar
class CommentsBottomSheet extends StatefulWidget {
  final TaskItem task;
  final String currentUser;

  const CommentsBottomSheet({
    super.key,
    required this.task,
    this.currentUser = 'Savaira',
  });

  static Future<void> show(
    BuildContext context,
    TaskItem task, {
    String currentUser = 'Savaira',
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: CommentsBottomSheet(
          task: task,
          currentUser: currentUser,
        ),
      ),
    );
  }

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final _inputController = TextEditingController();
  late List<CommentItem> _comments;

  @override
  void initState() {
    super.initState();
    _comments = DummyData.sampleComments
        .where((c) => c.taskId == widget.task.id)
        .toList();
    if (_comments.isEmpty) {
      _comments = [
        CommentItem(
          id: 'c_auto_1',
          taskId: widget.task.id,
          authorName: widget.currentUser == 'Savaira' ? 'Ayesha' : 'Savaira',
          isMine: false,
          text: 'Good luck with "${widget.task.title}"! 💕',
          timestamp: '10:00 AM',
        ),
      ];
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _sendComment() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _comments.add(
        CommentItem(
          id: 'comm_${DateTime.now().millisecondsSinceEpoch}',
          taskId: widget.task.id,
          authorName: widget.currentUser,
          isMine: true,
          text: text,
          timestamp: 'Just now',
        ),
      );
      _inputController.clear();
    });
  }

  void _deleteComment(int index) {
    setState(() {
      _comments.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.72,
      ),
      decoration: const BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.circleOutline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: AppColors.primaryBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Notes & Reflections', style: AppTypography.heading3),
                        Text(
                          widget.task.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const Divider(height: 16, color: AppColors.divider),

            // Comments List
            Expanded(
              child: _comments.isEmpty
                  ? Center(
                      child: Text(
                        'No comments yet. Leave a note or reflection!',
                        style: AppTypography.bodyMuted,
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        final c = _comments[index];
                        final isMine = c.isMine || c.authorName == widget.currentUser;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMine
                                ? AppColors.primaryBlueLight.withValues(alpha: 0.6)
                                : AppColors.surfaceMuted,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isMine
                                  ? AppColors.primaryBlueBorder
                                  : AppColors.borderSubtle,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        c.authorName,
                                        style: AppTypography.caption.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: isMine
                                              ? AppColors.primaryBlueDark
                                              : AppColors.user2Pink,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '• ${c.timestamp}',
                                        style: AppTypography.caption.copyWith(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (isMine)
                                    GestureDetector(
                                      onTap: () => _deleteComment(index),
                                      child: const Icon(
                                        Icons.delete_outline_rounded,
                                        size: 15,
                                        color: AppColors.dueRed,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(c.text, style: AppTypography.body),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            // Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.cardWhite,
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      decoration: InputDecoration(
                        hintText: 'Write a note or encouragement...',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: AppTheme.pillBorderRadius,
                          borderSide: const BorderSide(color: AppColors.borderSubtle),
                        ),
                      ),
                      onSubmitted: (_) => _sendComment(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryButtonGradient,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      onPressed: _sendComment,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
