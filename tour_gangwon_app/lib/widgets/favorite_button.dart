import 'package:flutter/material.dart';
import '../services/favorite_service.dart';
import '../services/api_client.dart';

class FavoriteButton extends StatefulWidget {
  final String placeId;
  final VoidCallback? onFavoriteChanged;
  final double size;
  final Color? favoriteColor;
  final Color? normalColor;

  const FavoriteButton({
    super.key,
    required this.placeId,
    this.onFavoriteChanged,
    this.size = 24.0,
    this.favoriteColor,
    this.normalColor,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final FavoriteService _favoriteService = FavoriteService();
  bool _isFavorite = false;
  bool _isLoading = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginAndFavoriteStatus();
  }

  Future<void> _checkLoginAndFavoriteStatus() async {
    try {
      final hasToken = await ApiClient.hasToken();
      setState(() {
        _isLoggedIn = hasToken;
      });

      if (hasToken) {
        await _checkFavoriteStatus();
      }
    } catch (e) {
      print('Error checking login status: $e');
    }
  }

  Future<void> _checkFavoriteStatus() async {
    if (!_isLoggedIn) return;

    try {
      final isFavorite = await _favoriteService.getFavoriteStatus(
        widget.placeId,
      );
      setState(() {
        _isFavorite = isFavorite;
      });
    } catch (e) {
      print('Error checking favorite status: $e');
    }
  }

  Future<void> _toggleFavorite() async {
    if (!_isLoggedIn) {
      _showLoginRequiredDialog();
      return;
    }

    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newStatus = await _favoriteService.toggleFavorite(widget.placeId);
      setState(() {
        _isFavorite = newStatus;
        _isLoading = false;
      });

      // 상태 변경 콜백 호출
      widget.onFavoriteChanged?.call();

      // 스낵바로 사용자에게 피드백
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newStatus ? '즐겨찾기에 추가되었습니다' : '즐겨찾기에서 삭제되었습니다'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그인 필요'),
        content: const Text('즐겨찾기 기능을 사용하려면 로그인이 필요합니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return IconButton(
        icon: Icon(
          Icons.favorite_border,
          size: widget.size,
          color: widget.normalColor ?? Colors.grey,
        ),
        onPressed: _toggleFavorite,
        tooltip: '즐겨찾기 추가 (로그인 필요)',
      );
    }

    return IconButton(
      icon: _isLoading
          ? SizedBox(
              width: widget.size * 0.8,
              height: widget.size * 0.8,
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              size: widget.size,
              color: _isFavorite
                  ? (widget.favoriteColor ?? Colors.red)
                  : (widget.normalColor ?? Colors.grey),
            ),
      onPressed: _isLoading ? null : _toggleFavorite,
      tooltip: _isFavorite ? '즐겨찾기 삭제' : '즐겨찾기 추가',
    );
  }
}
