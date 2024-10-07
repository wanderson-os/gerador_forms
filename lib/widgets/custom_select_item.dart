import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gerador_forms/model/item_data.dart';

class CustomSelectItemModal<T extends ItemData?> extends StatefulWidget {
  final List<T> itens;
  final T? initialvalue;
  final String label;
  final void Function(T? item) onSelectedItem;
  final void Function(T? item)? onSelectedItemSecundaryTap;
  final bool Function(T item)? isSelected;

  const CustomSelectItemModal(
      {super.key,
      required this.itens,
      required this.label,
      required this.initialvalue,
      required this.onSelectedItem,
      this.isSelected,
      this.onSelectedItemSecundaryTap});

  @override
  State<CustomSelectItemModal<T>> createState() =>
      _CustomSelectItemModalState<T>();
}

class _CustomSelectItemModalState<T extends ItemData?>
    extends State<CustomSelectItemModal<T>> {
  List<T> itens = [];
  bool isDarkTheme = false;
  Color colorBorder = Colors.black;
  T? selectedItem;
  late final searchEC = TextEditingController(
    text: widget.initialvalue?.toString() ?? '',
  );

  @override
  void initState() {
    selectedItem = widget.initialvalue;
    searchEC.text = widget.initialvalue?.toString() ?? '';
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {},
    );
  }

  @override
  void dispose() {
    searchEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    colorBorder = isDarkTheme ? Colors.white : Colors.black;

    return Tooltip(
      message: selectedItem?.toString() ?? '',
      child: InkWell(
        onTap: widget.itens.isNotEmpty
            ? () {
                searchEC.text = selectedItem?.toString() ?? '';
                itens = [
                  ...widget.itens.where(
                    (i) => i.toString().toLowerCase().contains(
                          searchEC.text.toLowerCase(),
                        ),
                  )
                ];
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) =>
                      StatefulBuilder(builder: (context, setStateBuilder) {
                    final total = widget.itens.length;
                    return AlertDialog(
                      actionsAlignment: MainAxisAlignment.spaceBetween,
                      actions: [
                        Text(
                          '$total Item${total > 1 ? 's' : ''}',
                        ),
                        TextButton(
                          onPressed: () {
                            if (searchEC.text.isEmpty) {
                              setState(
                                () {
                                  selectedItem = null;
                                  widget.onSelectedItem(null);
                                },
                              );
                            }
                            Navigator.of(context).pop();
                          },
                          child: const Text('Ok'),
                        )
                      ],
                      title: Text(
                        widget.label,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      content: Material(
                        clipBehavior: Clip.hardEdge,
                        color: Colors.transparent,
                        child: SizedBox(
                          height: 360,
                          width: 400,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: searchEC,
                                onChanged: (value) {
                                  setStateBuilder(
                                    () {
                                      itens = [
                                        ...widget.itens.where(
                                          (i) => (i
                                                      ?.filterString()
                                                      .toLowerCase() ??
                                                  i.toString().toLowerCase())
                                              .contains(value.toLowerCase()),
                                        )
                                      ];
                                    },
                                  );
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(
                                height: 300,
                                child: StatefulBuilder(
                                    builder: (context, setStateBuilder) {
                                  return ListView.builder(
                                    itemCount: itens.length,
                                    itemBuilder: (context, index) {
                                      final item = itens[index];
                                      final isSelected =
                                          widget.isSelected?.call(item) ??
                                              false;
                                      return Card(
                                        color: isSelected
                                            ? (Colors.blue.shade800)
                                            : null,
                                        child: InkWell(
                                          overlayColor: WidgetStateProperty.all(
                                            Colors.transparent,
                                          ),
                                          onSecondaryTap:
                                              widget.onSelectedItemSecundaryTap !=
                                                      null
                                                  ? () {
                                                      widget
                                                          .onSelectedItemSecundaryTap
                                                          ?.call(item);
                                                      setState(
                                                        () {
                                                          selectedItem = item;
                                                        },
                                                      );
                                                      setStateBuilder(() {});
                                                    }
                                                  : null,
                                          child: ListTile(
                                            splashColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            title: Text(
                                              item.toString(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: isSelected
                                                    ? Colors.white
                                                    : null,
                                              ),
                                            ),
                                            onTap: () {
                                              try {
                                                widget.onSelectedItem(item);
                                                setState(
                                                  () {
                                                    selectedItem = item;
                                                  },
                                                );
                                                Navigator.pop(context, item);
                                              } catch (e) {
                                                log(
                                                  e.toString(),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }
            : null,
        child: SizedBox(
          height: 50,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              const Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_drop_down,
                ),
              ),
              SizedBox(
                height: 50,
                child: InputDecorator(
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(4),
                    label: Text(
                      widget.label,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: widget.itens.isEmpty ? Colors.red : colorBorder,
                      ),
                    ),
                  ),
                  child: Text(
                    selectedItem?.toString() ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
