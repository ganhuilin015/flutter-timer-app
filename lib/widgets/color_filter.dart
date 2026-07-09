import 'package:flutter/material.dart';
import 'package:timer/widgets/color_utils.dart';


class ColorFilterButton extends StatelessWidget {
  final String? selectedColor;
  final ValueChanged<String?> onChanged;

  const ColorFilterButton({
    super.key,
    this.selectedColor,
    required this.onChanged,
  });


  void _showColorMenu(BuildContext context) async {

    final RenderBox button =
        context.findRenderObject() as RenderBox;

    final Offset position =
        button.localToGlobal(Offset.zero);

    final result = await showMenu<String?>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + button.size.height + 8,
        position.dx + button.size.width,
        0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      constraints: const BoxConstraints(
        minWidth: 36,
        maxWidth: 36,
      ),
      menuPadding: EdgeInsets.zero,
      items: [
        PopupMenuItem<String?>(
          value: null,
          padding: EdgeInsets.zero,
          height: 40,
          child: const SizedBox(
            width: 40,
            height: 40,
            child: Center(
              child: Icon(
                Icons.clear,
                size: 18,
              ),
            ),
          ),
        ),

        ...kPaletteColors.map(
          (hex) {
            return PopupMenuItem<String?>(
              value: hex,
              padding: EdgeInsets.zero,
              height: 40,
              child: SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: hexToColor(hex),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );

    if(result != null || selectedColor != null){
      onChanged(result);
    }

  }



  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => _showColorMenu(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey,
          ),

        ),


        child: selectedColor == null

            ? const Icon(
                Icons.filter_alt_outlined,
                size: 20,
              )
            : CircleAvatar(
                radius: 10,
                backgroundColor:
                    hexToColor(selectedColor!),
              ),

      ),

    );

  }
}