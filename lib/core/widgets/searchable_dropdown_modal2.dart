import 'package:eyvo_v3/core/resources/color_manager.dart';
import 'package:eyvo_v3/core/resources/font_manager.dart';
import 'package:flutter/material.dart';

class SearchableDropdownModal2 extends StatefulWidget {
  final List<String> items;
  final String? selectedValue;
  final bool showCodeAndDescription; // NEW: Add this parameter

  const SearchableDropdownModal2({
    Key? key,
    required this.items,
    this.selectedValue,
    this.showCodeAndDescription = false, // NEW: Default to false
  }) : super(key: key);

  @override
  State<SearchableDropdownModal2> createState() =>
      _SearchableDropdownModal2State();
}

class _SearchableDropdownModal2State extends State<SearchableDropdownModal2> {
  late List<String> filteredItems;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
    _searchController.addListener(() {
      setState(() {
        filteredItems = widget.items
            .where((e) =>
                e.toLowerCase().contains(_searchController.text.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // NEW: Helper method to build item with code and description
  Widget _buildItemContent(String item) {
    if (!widget.showCodeAndDescription) {
      return Text(
        item,
        style: TextStyle(
          fontSize: FontSize.s16,
          fontWeight: FontWeight.normal,
          color: ColorManager.black,
        ),
      );
    }

    // Split by ' - ' to separate code and description
    final parts = item.split(' - ');
    if (parts.length >= 2) {
      // Join all parts after the first one as description (in case there are multiple ' - ')
      final code = parts[0];
      final description = parts.sublist(1).join(' - ');
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            code, // Code part
            style: TextStyle(
              fontSize: FontSize.s16,
              fontWeight: FontWeight.w600,
              color: ColorManager.black,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            description, // Description part
            style: TextStyle(
              fontSize: FontSize.s14,
              fontWeight: FontWeight.normal,
              color: ColorManager.darkGrey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    } else {
      // Fallback if no ' - ' separator found
      return Text(
        item,
        style: TextStyle(
          fontSize: FontSize.s16,
          fontWeight: FontWeight.normal,
          color: ColorManager.black,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.6;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      height: height,
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Select Option",
                style: TextStyle(
                  fontSize: FontSize.s18,
                  fontWeight: FontWeight.w600,
                  color: ColorManager.darkBlue,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: ColorManager.grey, size: 20),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Search Box
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: ColorManager.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ColorManager.lightGrey.withOpacity(0.5),
              ),
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                fontSize: FontSize.s16,
                color: ColorManager.black,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(
                  fontSize: FontSize.s16,
                  color: ColorManager.grey,
                  fontWeight: FontWeight.normal,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: ColorManager.blue,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Divider
          Divider(
            color: ColorManager.lightGrey.withOpacity(0.3),
            height: 1,
            thickness: 1,
          ),

          const SizedBox(height: 8),
          Expanded(
            child: ScrollbarTheme(
              data: ScrollbarThemeData(
                thumbColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.dragged)) {
                    return ColorManager.darkBlue;
                  }
                  if (states.contains(WidgetState.hovered)) {
                    return ColorManager.blue.withOpacity(0.8);
                  }
                  return ColorManager.blue;
                }),
                trackColor: WidgetStateProperty.all(
                  ColorManager.lightGrey.withOpacity(0.2),
                ),
                thickness: WidgetStateProperty.all(6),
                radius: const Radius.circular(8),
                crossAxisMargin: 2,
                mainAxisMargin: 4,
                minThumbLength: 50,
              ),
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                interactive: true,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: filteredItems.length,
                  itemBuilder: (_, index) {
                    final item = filteredItems[index];
                    final isSelected = item == widget.selectedValue;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? ColorManager.blue.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: _buildItemContent(item), // UPDATED: Use new method
                        onTap: () {
                          Navigator.pop(context, item);
                        },
                        dense: widget.showCodeAndDescription ? false : true, // Adjust density for column layout
                        visualDensity: widget.showCodeAndDescription 
                            ? const VisualDensity(vertical: 0) // More space for column
                            : const VisualDensity(vertical: -2),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12, 
                          vertical: widget.showCodeAndDescription ? 8 : 4
                        ),
                        minVerticalPadding: widget.showCodeAndDescription ? 12 : 4,
                        trailing: isSelected
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: ColorManager.blue,
                                size: 20,
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}