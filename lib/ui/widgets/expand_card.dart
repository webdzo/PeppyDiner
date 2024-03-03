import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';


import 'package:flutter/material.dart';
import 'package:hotelpro_mobile/ui/widgets/expansion_panel_list.dart' as panel;

class ExpandCardWidget extends StatefulWidget {
  final Function() onRowClick;
  final bool isExpanded;
  final Widget header;
  final Widget body;
  const ExpandCardWidget({
    Key? key,
    this.isExpanded = false,
    required this.onRowClick,
    required this.header,
    required this.body,
  }) : super(key: key);

  @override
  State<ExpandCardWidget> createState() => _ExpandCardWidgetState();
}

class _ExpandCardWidgetState extends State<ExpandCardWidget> {
  String tappedButtonHeader = '';

  @override
  Widget build(BuildContext context) {
    return _buildRowWidget();
  }

  Widget _buildRowWidget() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(bottom: 10.w),
        padding: EdgeInsets.only(bottom: 5.w),
        decoration: BoxDecoration(
          /*  border: Border(
              bottom:
                  BorderSide(color: Theme.of(context).dividerColor, width: 1)), */
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        width: MediaQuery.of(context).size.width,
        child: InkWell(
          hoverColor: Colors.white,
          highlightColor: Colors.white,
          splashColor: Colors.white,
          onTap: () {},
          child: Theme(
            data: ThemeData().copyWith(
                dividerColor: Colors.transparent,
                cardColor: Theme.of(context).scaffoldBackgroundColor,
                colorScheme: Theme.of(context).colorScheme.copyWith(
                    background: Theme.of(context).colorScheme.background)),
            child: panel.AppExpansionPanelList(
              animationDuration: const Duration(milliseconds: 200),
              elevation: 0,
              expansionCallback: (int index, bool isExpanded) {
                widget.onRowClick();
              },
              children: [
                ExpansionPanel(
                  canTapOnHeader: true,
                  body: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: EdgeInsets.zero,
                    child: widget.body,
                  ),
                  headerBuilder: (context, isExpanded) {
                    return widget.header;
                  },
                  isExpanded: widget.isExpanded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
