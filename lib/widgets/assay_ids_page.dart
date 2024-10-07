import 'package:flutter/material.dart';
import 'package:gerador_forms/model/servico.dart';
import 'package:gerador_forms/widgets/custom_select_item.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class AssayIdsPage extends StatefulWidget {
  final List<Servico> itens;
  List<Servico> selecteds;
  Function(List<Servico> servicos) onConfirmSelection;
  AssayIdsPage(
      {super.key,
      required this.itens,
      required this.selecteds,
      required this.onConfirmSelection});

  @override
  State<AssayIdsPage> createState() => _AssayIdsPageState();
}

class _AssayIdsPageState extends State<AssayIdsPage> {
  List<Servico> selecteds = [];

  @override
  void initState() {
    selecteds = List.from(
      [
        ...widget.selecteds.map(
          (e) => e.copyWith(),
        ),
      ],
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assay Ids Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              widget.onConfirmSelection(
                selecteds,
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomSelectItemModal(
              itens: widget.itens,
              label: 'Serviços',
              initialvalue: null,
              isSelected: (servico) => selecteds.contains(servico),
              onSelectedItem: (value) {
                if (value == null) {
                  return;
                }
                setState(
                  () {
                    if (selecteds.contains(value)) {
                      selecteds.remove(value);
                    } else {
                      selecteds.add(value);
                    }
                  },
                );
              },
            ),
            Flexible(
              child: SuperListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(selecteds[index].name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(
                          () {
                            selecteds.removeAt(index);
                          },
                        );
                      },
                    ),
                  );
                },
                itemCount: selecteds.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
