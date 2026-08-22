import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:library_app1/core/theme_dev3/app_theme.dart';

import 'package:library_app1/features/book_details/presentation/pages/rent_book_page.dart';
import 'package:library_app1/features/book_details/presentation/pages/book_preview_page.dart';
import 'package:library_app1/features/book_details/presentation/pages/book_reader_page.dart';

import 'package:library_app1/features/book_details/presentation/bloc/book_details_bloc.dart';
import 'package:library_app1/features/book_details/presentation/bloc/book_details_event.dart';
import 'package:library_app1/features/book_details/presentation/bloc/book_details_state.dart';

import 'package:library_app1/features/home/presentation/bloc/Favorite_Bloc/favorite_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/Favorite_Bloc/favorite_event.dart';
import 'package:library_app1/features/home/presentation/bloc/Favorite_Bloc/favorite_state.dart';

import 'package:library_app1/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:library_app1/features/profile/presentation/bloc/profile_state.dart';

import 'package:library_app1/features/individual_challenge/presentation/individual_challenge_entry.dart';

class BookDetailsPage extends StatefulWidget {
  final int bookId;
  final String title;
  final String author;
  final String image;
  final String description;
  final String? pdfFile;

  const BookDetailsPage({
    super.key,
    required this.bookId,
    required this.title,
    required this.author,
    required this.image,
    required this.description,
    required this.pdfFile,
  });

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  // ============================================================
  // ACCESS
  // ============================================================

  bool _hasBookAccess = false;

  bool _actionInProgress = false;

  // ============================================================
  // RATING
  // ============================================================

  double? _myRating;

  bool _ratingLoading = true;

  bool _ratingDialogShowing = false;

  String get _ratingKey => 'book_rating_${widget.bookId}';

  // ============================================================
  // COMMENTS
  // ============================================================

  final Dio _commentsDio = Dio(
    BaseOptions(
      baseUrl: "http://10.243.228.50:8000/api/",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    ),
  );

  List<Map<String, dynamic>> _comments = [];

  bool _commentsLoading = false;
  bool _commentsLoaded = false;
  bool _addCommentLoading = false;

  final TextEditingController _commentController = TextEditingController();

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    context.read<BookDetailsBloc>().add(LoadBookDetailsEvent(widget.bookId));

    _loadMyRating();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentsDio.close();
    super.dispose();
  }

  // ============================================================
  // TOKEN
  // ============================================================

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('token') ??
        prefs.getString('auth_token') ??
        prefs.getString('access_token');
  }

  // ============================================================
  // LOAD COMMENTS
  // ============================================================

  Future<void> _loadComments() async {
    if (_commentsLoading) return;

    setState(() {
      _commentsLoading = true;
    });

    try {
      final token = await _getToken();

      final response = await _commentsDio.get(
        'comments/${widget.bookId}',
        options: Options(
          headers: {
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
          },
        ),
      );

      if (!mounted) return;

      final data = response.data;

      List<dynamic> commentsData = [];

      if (data is List) {
        commentsData = data;
      } else if (data is Map && data['data'] is List) {
        commentsData = data['data'];
      }

      setState(() {
        _comments = commentsData
            .whereType<Map>()
            .map((comment) => Map<String, dynamic>.from(comment))
            .toList();

        _commentsLoading = false;
        _commentsLoaded = true;
      });
    } on DioException catch (e) {
      if (!mounted) return;

      setState(() {
        _commentsLoading = false;
        _commentsLoaded = true;
      });

      String message = "Could not load comments";

      if (e.response?.data is Map && e.response?.data['message'] != null) {
        message = e.response?.data['message'].toString() ?? message;
      }

      _showMessage(message, AppTheme.errorRed);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _commentsLoading = false;
        _commentsLoaded = true;
      });

      _showMessage("Could not load comments", AppTheme.errorRed);
    }
  }

  // ============================================================
  // ADD COMMENT
  // ============================================================

  Future<void> _addComment() async {
    final body = _commentController.text.trim();

    if (body.isEmpty) {
      _showMessage("Please write a comment first", AppTheme.purpleDark);
      return;
    }

    if (body.length > 5000) {
      _showMessage("Comment cannot exceed 5000 characters", AppTheme.errorRed);
      return;
    }

    setState(() {
      _addCommentLoading = true;
    });

    try {
      final token = await _getToken();

      final response = await _commentsDio.post(
        'comments/${widget.bookId}',
        data: {'body': body},
        options: Options(
          headers: {
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
          },
        ),
      );

      if (!mounted) return;

      _commentController.clear();

      setState(() {
        _addCommentLoading = false;
      });

      Navigator.pop(context);

      _showMessage(
        response.data is Map && response.data['message'] != null
            ? response.data['message'].toString()
            : "Comment has been added successfully",
        Colors.green,
      );

      await _loadComments();
    } on DioException catch (e) {
      if (!mounted) return;

      setState(() {
        _addCommentLoading = false;
      });

      String message = "Could not add comment";

      if (e.response?.data is Map && e.response?.data['message'] != null) {
        message = e.response?.data['message'].toString() ?? message;
      }

      _showMessage(message, AppTheme.errorRed);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _addCommentLoading = false;
      });

      _showMessage("Could not add comment", AppTheme.errorRed);
    }
  }

  // ============================================================
  // DELETE COMMENT
  // ============================================================

  Future<void> _deleteComment(int commentId) async {
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
            style: TextStyle(color: AppTheme.textPrimary),
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
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: AppTheme.errorRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      final token = await _getToken();

      await _commentsDio.delete(
        'comments/$commentId',
        options: Options(
          headers: {
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
          },
        ),
      );

      if (!mounted) return;

      setState(() {
        _comments.removeWhere((comment) => comment['id'] == commentId);
      });

      _showMessage("Comment has been deleted successfully", Colors.green);
    } on DioException catch (e) {
      if (!mounted) return;

      String message = "Could not delete comment";

      if (e.response?.data is Map && e.response?.data['message'] != null) {
        message = e.response?.data['message'].toString() ?? message;
      }

      _showMessage(message, AppTheme.errorRed);
    } catch (e) {
      if (!mounted) return;

      _showMessage("Could not delete comment", AppTheme.errorRed);
    }
  }

  // ============================================================
  // COMMENT USER NAME
  // ============================================================

  String _commentUserName(Map<String, dynamic> comment) {
    final user = comment['users'] ?? comment['user'];

    if (user is Map) {
      final name = user['name'];

      if (name != null && name.toString().trim().isNotEmpty) {
        return name.toString();
      }
    }

    return "User";
  }

  // ============================================================
  // COMMENT DATE
  // ============================================================

  String _commentDate(Map<String, dynamic> comment) {
    final createdAt = comment['created_at'];

    if (createdAt == null) {
      return "";
    }

    try {
      final date = DateTime.parse(createdAt.toString()).toLocal();

      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year.toString();

      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');

      return "$day/$month/$year • $hour:$minute";
    } catch (_) {
      return createdAt.toString();
    }
  }

  // ============================================================
  // COMMENTS BOTTOM SHEET
  // ============================================================

  void _showCommentsSheet() {
    _loadComments();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.82,
              decoration: const BoxDecoration(
                color: AppTheme.pinkLight,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    Container(
                      width: 45,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppTheme.purpleSoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              gradient: AppTheme.purpleGradient,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.chat_bubble_rounded,
                              color: Colors.white,
                              size: 23,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Comments",
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.purpleDark,
                                  ),
                                ),
                                Text(
                                  "${_comments.length} comments",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Divider(color: AppTheme.purpleSoft, height: 1),

                    Expanded(
                      child: _commentsLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.purpleDark,
                              ),
                            )
                          : !_commentsLoaded
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.purpleDark,
                              ),
                            )
                          : _comments.isEmpty
                          ? _emptyComments()
                          : RefreshIndicator(
                              color: AppTheme.purpleDark,
                              onRefresh: () async {
                                await _loadComments();
                                setSheetState(() {});
                              },
                              child: ListView.builder(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  15,
                                  16,
                                  15,
                                ),
                                itemCount: _comments.length,
                                itemBuilder: (context, index) {
                                  return _commentCard(_comments[index]);
                                },
                              ),
                            ),
                    ),

                    Container(
                      padding: EdgeInsets.fromLTRB(
                        15,
                        10,
                        15,
                        MediaQuery.of(context).viewInsets.bottom + 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, -3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              maxLines: 4,
                              minLines: 1,
                              maxLength: 5000,
                              textInputAction: TextInputAction.newline,
                              decoration: InputDecoration(
                                hintText: "Write a comment...",
                                hintStyle: const TextStyle(
                                  color: AppTheme.textSecondary,
                                ),
                                filled: true,
                                fillColor: AppTheme.purpleLight,
                                counterText: "",
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 13,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                    color: AppTheme.purpleDark,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          SizedBox(
                            width: 52,
                            height: 52,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: AppTheme.purpleGradient,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: IconButton(
                                onPressed: _addCommentLoading
                                    ? null
                                    : () async {
                                        await _addComment();

                                        if (mounted) {
                                          setSheetState(() {});
                                        }
                                      },
                                icon: _addCommentLoading
                                    ? const SizedBox(
                                        width: 21,
                                        height: 21,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.send_rounded,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // EMPTY COMMENTS
  // ============================================================

  Widget _emptyComments() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
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
                fontSize: 20,
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
  // COMMENT CARD
  // ============================================================

  Widget _commentCard(Map<String, dynamic> comment) {
    final commentId = comment['id'];

    final userName = _commentUserName(comment);

    final body = comment['body']?.toString() ?? "";

    final date = _commentDate(comment);

    final prefsFuture = SharedPreferences.getInstance();

    return FutureBuilder<SharedPreferences>(
      future: prefsFuture,
      builder: (context, snapshot) {
        int? currentUserId;

        if (snapshot.hasData) {
          final prefs = snapshot.data!;

          currentUserId = prefs.getInt('user_id');
        }

        final commentUserId = comment['user_id'] is int
            ? comment['user_id'] as int
            : int.tryParse(comment['user_id']?.toString() ?? "");

        final canDelete =
            currentUserId != null &&
            commentUserId != null &&
            currentUserId == commentUserId;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.purpleLight),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  gradient: AppTheme.pinkGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : "U",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.purpleDark,
                            ),
                          ),
                        ),

                        if (canDelete && commentId != null)
                          PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.more_vert_rounded,
                              color: AppTheme.textSecondary,
                              size: 21,
                            ),
                            onSelected: (value) {
                              if (value == "delete") {
                                _deleteComment(int.parse(commentId.toString()));
                              }
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem<String>(
                                value: "delete",
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_outline,
                                      color: AppTheme.errorRed,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Delete",
                                      style: TextStyle(
                                        color: AppTheme.errorRed,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),

                    if (date.isNotEmpty) ...[
                      const SizedBox(height: 2),

                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],

                    const SizedBox(height: 9),

                    Text(
                      body,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // LOAD SAVED RATING
  // ============================================================

  Future<void> _loadMyRating() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final savedRating = prefs.getDouble(_ratingKey);

      if (!mounted) return;

      setState(() {
        _myRating = savedRating;
        _ratingLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _ratingLoading = false;
      });
    }
  }

  // ============================================================
  // SAVE RATING TO BACKEND
  // ============================================================

  Future<void> _saveRating(double rating) async {
    if (rating < 1 || rating > 5) {
      _showMessage("Rating must be between 1 and 5", AppTheme.errorRed);
      return;
    }

    try {
      final token = await _getToken();

      if (token == null || token.isEmpty) {
        _showMessage("Please login again", AppTheme.errorRed);
        return;
      }

      final dio = Dio(
        BaseOptions(
          baseUrl: "http://10.243.228.50:8000/api/",
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      Response response;

      try {
        response = await dio.post(
          'ratings/${widget.bookId}',
          data: {'rating': rating},
        );
      } on DioException catch (e) {
        if (e.response?.statusCode == 400 ||
            e.response?.statusCode == 409 ||
            e.response?.statusCode == 422) {
          response = await dio.put(
            'ratings/${widget.bookId}',
            data: {'rating': rating},
          );
        } else {
          rethrow;
        }
      }

      final prefs = await SharedPreferences.getInstance();

      await prefs.setDouble(_ratingKey, rating);

      if (!mounted) return;

      setState(() {
        _myRating = rating;
      });

      if (_ratingDialogShowing) {
        _ratingDialogShowing = false;
      }

      Navigator.pop(context);

      String message = "Your rating has been saved ⭐";

      if (response.data is Map && response.data['message'] != null) {
        message = response.data['message'].toString();
      }

      _showMessage(message, Colors.green);
    } on DioException catch (e) {
      if (!mounted) return;

      String message = "Could not save your rating";

      if (e.response?.data is Map) {
        final data = e.response!.data;

        if (data['message'] != null) {
          message = data['message'].toString();
        }

        if (data['errors'] is Map) {
          final errors = data['errors'] as Map;

          if (errors['rating'] is List &&
              (errors['rating'] as List).isNotEmpty) {
            message = (errors['rating'] as List).first.toString();
          }
        }
      }

      _showMessage(message, AppTheme.errorRed);
    } catch (e) {
      if (!mounted) return;

      _showMessage("Could not save your rating", AppTheme.errorRed);
    }
  }

  // ============================================================
  // RATING DIALOG
  // ============================================================

  void _showRatingDialog() {
    if (_ratingLoading) {
      return;
    }

    if (_ratingDialogShowing) {
      return;
    }

    _ratingDialogShowing = true;

    final bool hasPreviousRating = _myRating != null;

    double selectedRating = _myRating ?? 0;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 24,
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
                decoration: BoxDecoration(
                  color: AppTheme.pinkLight,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        gradient: AppTheme.pinkGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.star_rounded,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      hasPreviousRating ? "Your Rating" : "Rate This Book",
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.purpleDark,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      hasPreviousRating
                          ? "You already rated this book.\nWould you like to edit your rating?"
                          : "You finished reading this book!\nHow would you rate it?",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: AppTheme.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 22),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starValue = index + 1;

                        final isSelected = selectedRating >= starValue;

                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedRating = starValue.toDouble();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: AnimatedScale(
                              scale: isSelected ? 1.12 : 1.0,
                              duration: const Duration(milliseconds: 150),
                              child: Icon(
                                isSelected
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                size: 43,
                                color: isSelected
                                    ? AppTheme.pinkDark
                                    : AppTheme.purpleSoft,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 12),

                    if (selectedRating > 0)
                      Text(
                        "${selectedRating.toInt()} / 5",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.purpleDark,
                        ),
                      ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _ratingDialogShowing = false;

                              Navigator.pop(dialogContext);
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              side: const BorderSide(
                                color: AppTheme.purpleSoft,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: AppTheme.purpleDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: AppTheme.pinkGradient,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ElevatedButton(
                              onPressed: selectedRating == 0
                                  ? null
                                  : () async {
                                      await _saveRating(selectedRating);
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                disabledBackgroundColor: Colors.grey.shade300,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                hasPreviousRating ? "Update" : "Rate",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      _ratingDialogShowing = false;
    });
  }

  // ============================================================
  // PREVIEW
  // ============================================================

  void _openPreview(String? pdfFile, String bookTitle) {
    if (pdfFile == null || pdfFile.isEmpty) {
      _showMessage("PDF file is not available", AppTheme.errorRed);
      return;
    }

    final pdfUrl =
        pdfFile.startsWith('http://') || pdfFile.startsWith('https://')
        ? pdfFile
        : "http://10.243.228.50:8000/storage/$pdfFile";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookPreviewPage(
          pdfUrl: pdfUrl,
          bookTitle: bookTitle,
          bookId: widget.bookId,
          hasFullAccess: false,
        ),
      ),
    );
  }

  // ============================================================
  // FULL BOOK
  // ============================================================

  Future<void> _openFullBook(String? pdfFile, String bookTitle) async {
    if (pdfFile == null || pdfFile.isEmpty) {
      _showMessage("PDF file is not available", AppTheme.errorRed);
      return;
    }

    final pdfUrl =
        pdfFile.startsWith('http://') || pdfFile.startsWith('https://')
        ? pdfFile
        : "http://10.243.228.50:8000/storage/$pdfFile";

    // ==========================================================
    // مهم:
    // ننتظر رجوع المستخدم من قارئ الكتاب.
    // عند رجوعه نعرض التقييم تلقائياً.
    // ==========================================================

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookReaderPage(
          bookId: widget.bookId,
          pdfUrl: pdfUrl,
          bookTitle: bookTitle,
        ),
      ),
    );

    if (!mounted) return;

    // التقييم يظهر فقط للمستخدم الذي يملك وصولاً للكتاب
    await Future.delayed(const Duration(milliseconds: 250));

    if (!mounted) return;

    _showRatingDialog();
  }
  // ============================================================
  // PURCHASE
  // ============================================================

  void _purchaseBook(dynamic book) {
    final profileState = context.read<ProfileBloc>().state;

    int points = 0;
    double wallet = 0;

    if (profileState is ProfileLoaded) {
      points = profileState.profile.points;
      wallet = profileState.profile.walletBalance;
    }

    _showPurchaseSheet(book: book, points: points, wallet: wallet);
  }

  // ============================================================
  // BORROW / RENT
  // ============================================================

  void _borrowBook(dynamic book) {
    final profileState = context.read<ProfileBloc>().state;

    int points = 0;
    double wallet = 0;

    if (profileState is ProfileLoaded) {
      points = profileState.profile.points;
      wallet = profileState.profile.walletBalance;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RentBookPage(
          bookId: widget.bookId,
          book: book,
          points: points,
          wallet: wallet,
        ),
      ),
    );
  }

  // ============================================================
  // PURCHASE SHEET
  // ============================================================

  void _showPurchaseSheet({
    required dynamic book,
    required int points,
    required double wallet,
  }) {
    String selectedPackage = 'none';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final price = (book.sellingPrice as num).toDouble();

            final discountOptions = [
              {'package': 'none', 'discount': 0, 'points': 0},
              {'package': '15', 'discount': 10, 'points': 15},
              {'package': '30', 'discount': 20, 'points': 30},
              {'package': '45', 'discount': 30, 'points': 45},
              {'package': '60', 'discount': 40, 'points': 60},
              {'package': '75', 'discount': 50, 'points': 75},
            ];

            final selected = discountOptions.firstWhere(
              (option) => option['package'] == selectedPackage,
            );

            final discount = selected['discount'] as int;

            final requiredPoints = selected['points'] as int;

            final finalPrice = price * (1 - discount / 100);

            final canPay = points >= requiredPoints && wallet >= finalPrice;

            return Container(
              decoration: const BoxDecoration(
                color: AppTheme.purpleLight,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 25),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 45,
                          height: 5,
                          decoration: BoxDecoration(
                            color: AppTheme.purpleSoft,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Center(
                        child: Text(
                          "Purchase Book",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.purpleDark,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(
                              book.coverImage.startsWith('http')
                                  ? book.coverImage
                                  : "http://10.243.228.50:8000/storage/${book.coverImage}",
                              width: 75,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) {
                                return Container(
                                  width: 75,
                                  height: 100,
                                  color: AppTheme.purpleSoft,
                                  child: const Icon(
                                    Icons.book,
                                    size: 40,
                                    color: AppTheme.purpleDark,
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.bookName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  "Original price: ${price.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: _balanceCard(
                              icon: Icons.stars,
                              title: "Points",
                              value: "$points",
                              color: AppTheme.pinkDark,
                              lightColor: AppTheme.pinkLight,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: _balanceCard(
                              icon: Icons.account_balance_wallet,
                              title: "Wallet",
                              value: wallet.toStringAsFixed(2),
                              color: AppTheme.skyDark,
                              lightColor: AppTheme.skyLight,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        "Choose your discount",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.purpleDark,
                        ),
                      ),

                      const SizedBox(height: 12),

                      ...discountOptions.map((option) {
                        final package = option['package'] as String;

                        final optionDiscount = option['discount'] as int;

                        final optionPoints = option['points'] as int;

                        final optionPrice = price * (1 - optionDiscount / 100);

                        final enabled = points >= optionPoints;

                        final isSelected = selectedPackage == package;

                        return GestureDetector(
                          onTap: enabled
                              ? () {
                                  setSheetState(() {
                                    selectedPackage = package;
                                  });
                                }
                              : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? AppTheme.purpleGradient
                                  : null,
                              color: isSelected
                                  ? null
                                  : enabled
                                  ? Colors.white
                                  : AppTheme.borderLight,
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.purpleDark
                                    : AppTheme.borderLight,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: isSelected
                                      ? Colors.white
                                      : enabled
                                      ? AppTheme.purpleDark
                                      : Colors.grey,
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        optionDiscount == 0
                                            ? "No Discount"
                                            : "$optionDiscount% OFF",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Colors.white
                                              : enabled
                                              ? AppTheme.textPrimary
                                              : Colors.grey,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        optionPoints == 0
                                            ? "No points required"
                                            : "$optionPoints points",
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white70
                                              : AppTheme.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Text(
                                  optionPrice.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : enabled
                                        ? AppTheme.purpleDark
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 15),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: const BoxDecoration(
                          gradient: AppTheme.pinkGradient,
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Final Price",
                              style: TextStyle(
                                color: AppTheme.pinkDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              finalPrice.toStringAsFixed(2),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.pinkDark,
                              ),
                            ),

                            if (discount > 0)
                              Text(
                                "You save ${(price - finalPrice).toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: AppTheme.pinkDark,
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      if (!canPay)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            color: AppTheme.pinkLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            points < requiredPoints
                                ? "You don't have enough points for this discount."
                                : "You don't have enough wallet balance.",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppTheme.pinkDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: AppTheme.purpleGradient,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ElevatedButton(
                            onPressed: canPay
                                ? () {
                                    Navigator.pop(sheetContext);

                                    setState(() {
                                      _actionInProgress = true;
                                    });

                                    context.read<BookDetailsBloc>().add(
                                      PurchaseBookEvent(
                                        widget.bookId,
                                        selectedPackage,
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              disabledBackgroundColor: Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "PURCHASE NOW",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // BALANCE CARD
  // ============================================================

  Widget _balanceCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Color lightColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 25),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12, color: color)),

                Text(
                  value,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CHALLENGE
  // ============================================================

  void _openChallenge(String bookTitle) {
    openIndividualChallengeFlow(
      context,
      bookId: widget.bookId,
      bookTitle: bookTitle,
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
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

        title: const Text(
          "Book Details",
          style: TextStyle(
            color: AppTheme.pinkDark,
            fontWeight: FontWeight.bold,
          ),
        ),

        iconTheme: const IconThemeData(color: AppTheme.pinkDark),

        actions: [
          // ======================================================
          // RATING
          // ======================================================
          //
          // لا يظهر زر التقييم إلا إذا كان المستخدم يملك الكتاب.
          // ======================================================
          IconButton(
            tooltip: _myRating == null ? "Rate this book" : "Edit your rating",
            icon: _ratingLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.pinkDark,
                    ),
                  )
                : Icon(
                    _myRating != null
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: AppTheme.pinkDark,
                    size: 28,
                  ),
            onPressed: _ratingLoading ? null : _showRatingDialog,
          ),

          // ======================================================
          // FAVORITE
          // ======================================================
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              bool isFav = false;

              if (state is FavoriteLoaded) {
                isFav = state.favoriteBooks.any(
                  (book) => book.id == widget.bookId,
                );
              }

              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: AppTheme.pinkDark,
                ),
                onPressed: () {
                  context.read<FavoriteBloc>().add(
                    ToggleFavoriteEvent(
                      token: "",
                      bookId: widget.bookId,
                      isCurrentlyFavorite: isFav,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),

      body: BlocListener<BookDetailsBloc, BookDetailsState>(
        listener: (context, state) {
          if (state is BookDetailsLoaded) {
            if (_actionInProgress && state.hasAccess) {
              setState(() {
                _hasBookAccess = true;
                _actionInProgress = false;
              });

              _showMessage(
                "You now have access to this book! 🎉",
                Colors.green,
              );
            }
          }

          if (state is BookDetailsActionError) {
            if (_actionInProgress) {
              setState(() {
                _actionInProgress = false;
              });
            }

            _showMessage(state.message, AppTheme.errorRed);
          }
        },
        child: BlocBuilder<BookDetailsBloc, BookDetailsState>(
          builder: (context, state) {
            if (state is BookDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.pinkDark),
              );
            }

            if (state is BookDetailsError) {
              return Center(
                child: Text(state.message, textAlign: TextAlign.center),
              );
            }

            if (state is BookDetailsPurchaseLoading) {
              return Stack(
                children: [
                  _buildBookDetails(state.book, false),
                  _loadingOverlay("Purchasing book..."),
                ],
              );
            }

            if (state is BookDetailsBorrowLoading) {
              return Stack(
                children: [
                  _buildBookDetails(state.book, false),
                  _loadingOverlay("Borrowing book..."),
                ],
              );
            }

            if (state is BookDetailsActionError) {
              return _buildBookDetails(state.book, state.hasAccess);
            }

            if (state is BookDetailsLoaded) {
              return _buildBookDetails(state.book, state.hasAccess);
            }

            return const Center(
              child: CircularProgressIndicator(color: AppTheme.pinkDark),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // LOADING OVERLAY
  // ============================================================

  Widget _loadingOverlay(String text) {
    return Container(
      color: Colors.black.withOpacity(0.25),
      child: Center(
        child: Card(
          color: AppTheme.pinkLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: AppTheme.pinkDark),

                const SizedBox(height: 15),

                Text(
                  text,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.pinkDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BOOK DETAILS
  // ============================================================

  Widget _buildBookDetails(dynamic book, bool hasAccess) {
    final access = hasAccess || _hasBookAccess;

    // نثبت حالة الوصول حتى يظهر زر التقييم
    // مباشرة بعد نجاح الشراء/الاستعارة.
    if (access && !_hasBookAccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_hasBookAccess) {
          setState(() {
            _hasBookAccess = true;
          });
        }
      });
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
      child: Column(
        children: [
          // COVER
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.pinkSoft, AppTheme.purpleSoft],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0, 7),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.network(
                book.coverImage.startsWith('http')
                    ? book.coverImage
                    : "http://10.243.228.50:8000/storage/${book.coverImage}",
                width: 190,
                height: 270,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    width: 190,
                    height: 270,
                    color: AppTheme.purpleLight,
                    child: const Icon(
                      Icons.menu_book_rounded,
                      size: 90,
                      color: AppTheme.purpleDark,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 22),

          // TITLE
          Text(
            book.bookName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.purpleDark,
            ),
          ),

          const SizedBox(height: 8),

          if (book.authors.isNotEmpty)
            Text(
              book.authors.join(" • "),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: AppTheme.textSecondary,
              ),
            ),

          const SizedBox(height: 18),

          // QUICK INFO
          Row(
            children: [
              Expanded(
                child: _infoCard(
                  Icons.star_rounded,
                  "Rating",
                  book.rating.toString(),
                  AppTheme.pinkDark,
                  AppTheme.pinkLight,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _infoCard(
                  Icons.menu_book_rounded,
                  "Pages",
                  "${book.pages}",
                  AppTheme.skyDark,
                  AppTheme.skyLight,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _infoCard(
                  Icons.language_rounded,
                  "Language",
                  book.language,
                  AppTheme.purpleDark,
                  AppTheme.purpleLight,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // DESCRIPTION
          _sectionCard(
            title: "Description",
            icon: Icons.description_outlined,
            color: AppTheme.pinkDark,
            lightColor: AppTheme.pinkLight,
            child: Text(
              book.description,
              style: const TextStyle(
                height: 1.6,
                fontSize: 15,
                color: AppTheme.textPrimary,
              ),
            ),
          ),

          const SizedBox(height: 15),

          // AUTHORS
          _sectionCard(
            title: "Authors",
            icon: Icons.person_outline,
            color: AppTheme.skyDark,
            lightColor: AppTheme.skyLight,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: book.authors.map<Widget>((author) {
                return _tag(author, AppTheme.skySoft, AppTheme.skyDark);
              }).toList(),
            ),
          ),

          const SizedBox(height: 15),

          // CATEGORIES
          _sectionCard(
            title: "Categories",
            icon: Icons.category_outlined,
            color: AppTheme.purpleDark,
            lightColor: AppTheme.purpleLight,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: book.categories.map<Widget>((category) {
                return _tag(category, AppTheme.purpleSoft, AppTheme.purpleDark);
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          // ACCESS
          if (access)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: AppTheme.skyGradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock_open_rounded, color: AppTheme.skyDark),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "You have access to this book",
                      style: TextStyle(
                        color: AppTheme.skyDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          if (access) const SizedBox(height: 15),

          // READ
          _gradientButton(
            text: access ? "Read Full Book" : "Read Preview • First 5 Pages",
            icon: access ? Icons.menu_book_rounded : Icons.preview_rounded,
            colors: access
                ? const [AppTheme.skyDark, AppTheme.skyMedium]
                : const [AppTheme.pinkMedium, AppTheme.pinkDark],
            onPressed: () {
              if (access) {
                _openFullBook(book.pdfFile, book.bookName);
              } else {
                _openPreview(book.pdfFile, book.bookName);
              }
            },
          ),

          // CHALLENGE
          if (access) ...[
            const SizedBox(height: 12),

            _gradientButton(
              text: "Individual Challenge",
              icon: Icons.emoji_events_rounded,
              colors: const [AppTheme.purpleMedium, AppTheme.purpleDark],
              onPressed: () {
                _openChallenge(book.bookName);
              },
            ),
          ],

          // BUY + RENT
          if (!access) ...[
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _gradientButton(
                    text: "Buy",
                    icon: Icons.shopping_bag_outlined,
                    colors: const [AppTheme.purpleMedium, AppTheme.purpleDark],
                    onPressed: () {
                      _purchaseBook(book);
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _gradientButton(
                    text: "Rent",
                    icon: Icons.bookmark_add_outlined,
                    colors: const [AppTheme.skyMedium, AppTheme.skyDark],
                    onPressed: () {
                      _borrowBook(book);
                    },
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 12),

          // COMMENTS
          OutlinedButton.icon(
            onPressed: _showCommentsSheet,
            icon: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: AppTheme.purpleDark,
            ),
            label: const Text(
              "Comments",
              style: TextStyle(
                color: AppTheme.purpleDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              backgroundColor: AppTheme.purpleLight,
              side: const BorderSide(color: AppTheme.purpleSoft),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFO CARD
  // ============================================================

  Widget _infoCard(
    IconData icon,
    String title,
    String value,
    Color color,
    Color lightColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 7),
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 25),

          const SizedBox(height: 5),

          Text(title, style: TextStyle(fontSize: 11, color: color)),

          const SizedBox(height: 2),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION CARD
  // ============================================================

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required Color lightColor,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: lightColor),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: lightColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),

              const SizedBox(width: 10),

              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          child,
        ],
      ),
    );
  }

  // ============================================================
  // TAG
  // ============================================================

  Widget _tag(String text, Color background, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  // ============================================================
  // GRADIENT BUTTON
  // ============================================================

  Widget _gradientButton({
    required String text,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.last.withOpacity(0.20),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
