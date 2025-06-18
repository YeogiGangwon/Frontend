import 'package:flutter/material.dart';

class MessageWthLink extends StatefulWidget {
  const MessageWthLink({super.key});

  @override
  State<MessageWthLink> createState() => _MessageWthLinkState();
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String route;
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

class _MessageWthLinkState extends State<MessageWthLink> {
  bool isSearchMode = false;
  final TextEditingController _searchController = TextEditingController();

  final List<_MenuItem> menuItems = const [
    _MenuItem(icon: Icons.home, label: '홈', route: '/home'),
    _MenuItem(icon: Icons.star, label: '추천받기', route: '/search_result_list'),
    _MenuItem(icon: Icons.favorite, label: '즐겨찾기', route: '/favorites_list'),
    _MenuItem(icon: Icons.person, label: '마이페이지', route: '/mypage'),
  ];

  void _onNavTap(int idx) {
    setState(() {
      isSearchMode = false;
    });
    final item = menuItems[idx];
    if (item.route == '/search_result_list') {
      Navigator.pushNamed(context, item.route, arguments: DateTime.now());
    } else {
      Navigator.pushNamed(context, item.route);
    }
  }

  void _onSearchTap() {
    setState(() {
      isSearchMode = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double barHeight = 74;
    final double buttonHeight = 60;
    final double buttonWidth = 64;
    final double buttonRadius = 30;
    final double barRadius = 40;
    final double barOpacity = 0.05; // 더 투명하게
    final double borderWidth = 1.5;
    final Color selectedColor = Colors.redAccent;
    final Color unselectedColor = Colors.black87;
    final Color barBorderColor = Colors.white.withOpacity(0.7);

    // 현재 라우트명 얻기
    String? currentRoute = ModalRoute.of(context)?.settings.name;
    // search_result_list 라우트 체크
    bool isRecommendRoute = currentRoute == '/search_result_list';

    return Container(
      width: double.infinity,
      height: barHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Main pill bar
          Expanded(
            child: Container(
              height: buttonHeight + 12,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(barOpacity),
                borderRadius: BorderRadius.circular(barRadius),
                border: Border.all(color: barBorderColor, width: borderWidth),
              ),
              child: isSearchMode
                  ? Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: Colors.black54),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  autofocus: true,
                                  decoration: const InputDecoration(
                                    hintText: '검색어를 입력하세요',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    isSearchMode = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(menuItems.length, (idx) {
                        final _MenuItem item = menuItems[idx];
                        bool selected = false;
                        if (item.route == '/search_result_list') {
                          selected = isRecommendRoute;
                        } else {
                          selected = currentRoute == item.route;
                        }
                        return GestureDetector(
                          onTap: () => _onNavTap(idx),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: buttonWidth,
                            height: buttonHeight,
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: selected
                                  ? selectedColor.withOpacity(0.12)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(buttonRadius),
                              border: selected
                                  ? Border.all(color: selectedColor, width: 2)
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  item.icon,
                                  color: selected
                                      ? selectedColor
                                      : unselectedColor,
                                  size: 28,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: selected
                                        ? selectedColor
                                        : unselectedColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          // Search button (always visible, round)
          isSearchMode
              ? const SizedBox(width: 60) // placeholder for symmetry
              : GestureDetector(
                  onTap: _onSearchTap,
                  child: Container(
                    width: buttonHeight,
                    height: buttonHeight,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05), // 더 투명하게
                      shape: BoxShape.circle,
                      border: Border.all(color: barBorderColor, width: 2),
                    ),
                    child: Icon(Icons.search, color: unselectedColor, size: 28),
                  ),
                ),
        ],
      ),
    );
  }
}
