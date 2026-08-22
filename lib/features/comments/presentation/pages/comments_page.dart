import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:library_app1/core/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:library_app1/core/network_dev3/api_client.dart';
import 'package:library_app1/core/theme_dev3/app_theme.dart';

import '../../data/models/comment_model.dart';

class CommentsPage extends StatefulWidget {
  final int bookId;
  final String bookTitle;

  const CommentsPage({
    super.key,
    required this.bookId,
    required this.bookTitle,
  });

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  late final Dio _dio;

  final TextEditingController _commentController = TextEditingController();

  List<CommentModel> _comments = [];

  bool _loading = true;
  bool _addingComment = false;

  int? _currentUserId;

  @override
  void initState() {
    super.initState();

    _dio = ApiClient().dio;

    _loadCurrentUser();
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // ============================================================
  // CURRENT USER
  // ============================================================

  Future<void> _loadCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();

      // حسب مشروعك ممكن يكون محفوظ user_id
      final userId = prefs.getInt('user_id');

      if (!mounted) return;

      setState(() {
        _currentUserId = userId;
      });
    } catch (e) {
      debugPrint("❌ Failed to load current user: $e");
    }
  }

  // ============================================================
  // GET COMMENTS
  // ============================================================

  Future<void> _loadComments() async {
    if (!mounted) return;

    setState(() {
      _loading = true;
    });

    try {
      final response = await _dio.get('/comments/${widget.bookId}');

      debugPrint("💬 COMMENTS RESPONSE:");
      debugPrint(response.data.toString());

      final data = response.data;

      List rawComments = [];

      if (data is List) {
        rawComments = data;
      } else if (data is Map && data['data'] is List) {
        rawComments = data['data'];
      }

      final comments = rawComments
          .map((item) => CommentModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      if (!mounted) return;

      setState(() {
        _comments = comments;
        _loading = false;
      });
    } on DioException catch (e) {
      debugPrint("❌ Get Comments Error:");
      debugPrint(e.response?.data?.toString());
      debugPrint(e.message);

      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      _showMessage(
        _extractErrorMessage(e, "Could not load comments"),
        AppTheme.errorRed,
      );
    } catch (e) {
      debugPrint("❌ Get Comments Error: $e");

      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      _showMessage("Could not load comments", AppTheme.errorRed);
    }
  }

  // ============================================================
  // ADD COMMENT
  // ============================================================

  Future<void> _addComment() async {
    final text = _commentController.text.trim();

    if (text.isEmpty) {
      _showMessage("Please write a comment first", AppTheme.purpleDark);
      return;
    }

    if (_addingComment) return;

    setState(() {
      _addingComment = true;
    });

    try {
      final response = await _dio.post(
        '/comments/${widget.bookId}',
        data: {'body': text},
      );

      debugPrint("✅ ADD COMMENT RESPONSE:");
      debugPrint(response.data.toString());

      _commentController.clear();

      if (!mounted) return;

      setState(() {
        _addingComment = false;
      });

      _showMessage("Comment added successfully 💬", Colors.green);

      // إعادة جلب التعليقات حتى يظهر التعليق الجديد
      await _loadComments();
    } on DioException catch (e) {
      debugPrint("❌ Add Comment Error:");
      debugPrint(e.response?.data?.toString());
      debugPrint(e.message);

      if (!mounted) return;

      setState(() {
        _addingComment = false;
      });

      _showMessage(
        _extractErrorMessage(e, "Could not add comment"),
        AppTheme.errorRed,
      );
    } catch (e) {
      debugPrint("❌ Add Comment Error: $e");

      if (!mounted) return;

      setState(() {
        _addingComment = false;
      });

      _showMessage("Could not add comment", AppTheme.errorRed);
    }
  }

  // ============================================================
  // DELETE COMMENT
  // ============================================================

  Future<void> _deleteComment(CommentModel comment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.pinkLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Delete Comment",
            style: TextStyle(
              color: AppTheme.purpleDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Are you sure you want to delete this comment?",
            style: TextStyle(color: AppTheme.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: AppTheme.purpleDark),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorRed,
              ),
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await _dio.delete('/comments/${comment.id}');

      if (!mounted) return;

      _showMessage("Comment deleted successfully", Colors.green);

      await _loadComments();
    } on DioException catch (e) {
      debugPrint("❌ Delete Comment Error:");
      debugPrint(e.response?.data?.toString());

      if (!mounted) return;

      _showMessage(
        _extractErrorMessage(e, "Could not delete comment"),
        AppTheme.errorRed,
      );
    } catch (e) {
      debugPrint("❌ Delete Comment Error: $e");

      if (!mounted) return;

      _showMessage("Could not delete comment", AppTheme.errorRed);
    }
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  String _extractErrorMessage(DioException e, String defaultMessage) {
    final data = e.response?.data;

    if (data is Map) {
      if (data['message'] != null) {
        return data['message'].toString();
      }

      if (data['errors'] is Map) {
        final errors = data['errors'] as Map;

        if (errors.isNotEmpty) {
          final firstError = errors.values.first;

          if (firstError is List && firstError.isNotEmpty) {
            return firstError.first.toString();
          }

          return firstError.toString();
        }
      }
    }

    return defaultMessage;
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message, Color color) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // DATE
  // ============================================================

  String _formatDate(DateTime? date) {
    if (date == null) return '';

    final localDate = date.toLocal();

    return '${localDate.day.toString().padLeft(2, '0')}/'
        '${localDate.month.toString().padLeft(2, '0')}/'
        '${localDate.year}';
  }

  // ============================================================
  // COMMENT CARD
  // ============================================================

  Widget _commentCard(CommentModel comment) {
    final bool isMyComment =
        _currentUserId != null && _currentUserId == comment.userId;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.purpleSoft),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 7, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  gradient: AppTheme.purpleGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_rounded, color: Colors.white),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.userName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.purpleDark,
                      ),
                    ),

                    if (comment.createdAt != null)
                      Text(
                        _formatDate(comment.createdAt),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),

              if (isMyComment)
                IconButton(
                  tooltip: "Delete",
                  onPressed: () {
                    _deleteComment(comment);
                  },
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppTheme.errorRed,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 13),

          Text(
            comment.body,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _emptyComments() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppTheme.purpleLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 45,
                color: AppTheme.purpleDark,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              "No comments yet",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: AppTheme.purpleDark,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Be the first one to share your thoughts about this book.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ADD COMMENT FIELD
  // ============================================================

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppTheme.purpleSoft)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: "Write a comment...",
                  hintStyle: const TextStyle(color: AppTheme.textSecondary),
                  filled: true,
                  fillColor: AppTheme.purpleLight,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppTheme.purpleGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                onPressed: _addingComment ? null : _addComment,
                icon: _addingComment
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pinkLight,

      appBar: AppBar(
        backgroundColor: AppTheme.pinkLight,
        elevation: 0,
        centerTitle: true,

        iconTheme: const IconThemeData(color: AppTheme.purpleDark),

        title: Column(
          children: [
            const Text(
              "Comments",
              style: TextStyle(
                color: AppTheme.purpleDark,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              widget.bookTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            tooltip: "Refresh",
            onPressed: _loading ? null : _loadComments,
            icon: const Icon(Icons.refresh_rounded, color: AppTheme.purpleDark),
          ),
        ],
      ),

      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.purpleDark),
            )
          : _comments.isEmpty
          ? _emptyComments()
          : RefreshIndicator(
              color: AppTheme.purpleDark,
              onRefresh: _loadComments,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  return _commentCard(_comments[index]);
                },
              ),
            ),

      bottomNavigationBar: _buildCommentInput(),
    );
  }
}
