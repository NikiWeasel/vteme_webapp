import 'package:flutter/cupertino.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';
import 'package:vteme_tg_miniapp/features/home/view/widgets/regulation_tile.dart';

class RegSelectionContent extends StatefulWidget {
  const RegSelectionContent({super.key, required this.regs});

  final List<Regulation> regs;

  @override
  State<RegSelectionContent> createState() => _RegSelectionContentState();
}

class _RegSelectionContentState extends State<RegSelectionContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                for (var r in widget.regs)
                  RegulationTile(
                    regulation: r,
                    onPressed: () {},
                    isSecondaryScreen: true,
                  )
              ],
            ),
          ),
        )
      ],
    );
  }
}
