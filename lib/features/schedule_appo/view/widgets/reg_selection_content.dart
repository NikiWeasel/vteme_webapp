import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';
import 'package:vteme_tg_miniapp/features/home/view/widgets/regulation_tile.dart';

class RegSelectionContent extends StatefulWidget {
  const RegSelectionContent(
      {super.key, required this.regs, required this.onSelected});

  final List<Regulation> regs;
  final void Function(List<Regulation>) onSelected;

  @override
  State<RegSelectionContent> createState() => _RegSelectionContentState();
}

class _RegSelectionContentState extends State<RegSelectionContent> {
  bool isTextFieldEmpty = true;
  late List<Regulation> filteredRegs;

  List<Regulation> selectedRegs = [];

  late TextEditingController controller;

  late Map<String, bool> boolMap;

  int finalCost = 0;

  int finalDuration = 0;

  @override
  void initState() {
    super.initState();
    filteredRegs = widget.regs;
    controller = TextEditingController();
    boolMap = Map.fromEntries(widget.regs.map(
      (e) => MapEntry(e.id ?? 'null', false),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void deleteString() {
    controller.clear();
    // controller.text = '';

    setState(() {
      filteredRegs = widget.regs;
    });
  }

  void onChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        isTextFieldEmpty = true;
        filteredRegs = widget.regs;
      });
    } else {
      setState(() {
        isTextFieldEmpty = false;
        filterRegs(value);
      });
    }
  }

  void filterRegs(String search) {
    setState(() {
      filteredRegs = filteredRegs
          .where(
            (e) => ('${e.name} ${e.cost} ${e.duration}').contains(search),
          )
          .toList();
    });
  }

  void onChangedCheckBox(String id, bool value) {
    setState(() {
      boolMap[id] = value;
    });
  }

  void setSelectedRegs() {
    List<String> trueKeys = boolMap.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    selectedRegs =
        widget.regs.where((element) => trueKeys.contains(element.id)).toList();

    print(selectedRegs);
  }

  void onContinueButton() {
    print(selectedRegs);
    if (selectedRegs.isEmpty) return;

    widget.onSelected(selectedRegs);
  }

  void countFinalVars() {
    finalDuration = 0;
    finalCost = 0;

    for (var e in selectedRegs) {
      setState(() {
        finalCost += e.cost;
        finalDuration += e.duration;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double activeWidth = MediaQuery.of(context).size.width <= 800
        ? MediaQuery.of(context).size.width
        : 800;

    //TODO сделать выбор не более 5 услуг

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        bottomNavigationBar: selectedRegs.isNotEmpty
            ? Container(
                // height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$finalCost руб',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.surface),
                          ),
                          Text(
                            '${selectedRegs.length} услуг | $finalDuration минут',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.surface),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton(
                          onPressed: onContinueButton,
                          child: const Text('Продолжить'))
                    ],
                  ),
                ),
              )
            : null,
        body: Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: activeWidth < 800
                ? constraints.maxWidth
                : constraints.maxWidth / 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                      ),
                      child: TextField(
                        controller: controller,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            hintText: 'Поиск по названию, длительности',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: isTextFieldEmpty
                                ? null
                                : IconButton(
                                    onPressed: deleteString,
                                    icon: const Icon(Icons.close),
                                  )),
                        onChanged: onChanged,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          for (var r in filteredRegs)
                            Stack(
                              children: [
                                RegulationTile(
                                  regulation: r,
                                  onPressed: () {
                                    widget.onSelected([r]);
                                  },
                                  isSecondaryScreen: true,
                                ),
                                Positioned(
                                    right: 5,
                                    bottom: 8,
                                    child: Checkbox(
                                        value: boolMap[r.id],
                                        onChanged: (value) {
                                          if (value == null) return;
                                          onChangedCheckBox(
                                              r.id ?? 'null', value);

                                          setSelectedRegs();
                                          countFinalVars();
                                        }))
                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
