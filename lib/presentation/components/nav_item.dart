import 'package:flutter/material.dart';

import '../themes/colors.dart';

class NavItem extends StatefulWidget {
  final IconData? icon;
  final String label;
  final int value;
  final int groupValue;
  final bool isSelected;
  final ValueChanged<int>? onChanged;

  const NavItem(
      {Key? key,
      this.icon,
      required this.label,
      required this.value,
      required this.groupValue,
      required this.onChanged,
      required this.isSelected})
      : super(key: key);

  @override
  _NavItemState createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  void _handleTap() {
    widget.onChanged!(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            size: 25,
            color: widget.isSelected ? AppColors.primary : AppColors.blueGrey[300],
          ),
          const SizedBox(height: 5),
          Text(
            widget.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: widget.isSelected ? AppColors.primary : AppColors.blueGrey[300],
            ),
          )
        ],
      ),
    );
  }
}
