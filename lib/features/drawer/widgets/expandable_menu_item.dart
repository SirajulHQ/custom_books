import 'package:custom_books/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class ExpandableMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> subItems;
  final bool isExpanded;
  final VoidCallback onTap;
  final Function(String)? onSubItemTap;

  const ExpandableMenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.subItems,
    required this.isExpanded,
    required this.onTap,
    this.onSubItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            width: Dimensions.height45 * 0.9,
            height: Dimensions.height45 * 0.9,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(Dimensions.radius15),
            ),
            child: Icon(
              icon,
              size: Dimensions.iconSize24 * 0.9,
              color: Colors.black54,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.9,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          trailing: Icon(
            isExpanded
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            size: Dimensions.iconSize24,
            color: Colors.black54,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: Dimensions.width20,
            vertical: Dimensions.height10 / 4,
          ),
          onTap: onTap,
        ),
        if (isExpanded)
          ...subItems.map(
            (subItem) => ListTile(
              leading: SizedBox(width: Dimensions.height45 * 0.9),
              title: Padding(
                padding: EdgeInsets.only(left: Dimensions.width10),
                child: Text(
                  subItem,
                  style: TextStyle(
                    fontSize: Dimensions.font16 * 0.85,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
              ),
              dense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: 0,
              ),
              onTap: () {
                if (onSubItemTap != null) {
                  onSubItemTap!(subItem);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
      ],
    );
  }
}
