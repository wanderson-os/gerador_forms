import 'package:flutter/material.dart';
import 'package:gerador_forms/interface/i_form.dart' as f;

class CalculateFieldText extends StatefulWidget {
  final List<({String name, String type})> itens;
  final Function(String expression) onSave;
  final f.FormField field;
  const CalculateFieldText({
    super.key,
    required this.itens,
    required this.onSave,
    required this.field,
  });

  @override
  State<CalculateFieldText> createState() => _CalculateFieldTextState();
}

class _CalculateFieldTextState extends State<CalculateFieldText> {
  final controller = TextEditingController();
  final previewController = TextEditingController();

  @override
  void initState() {
    if (widget.field.expression != null) {
      controller.text = widget.field.expression!;
    }
    updatePreview(controller.text);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expressão do campo caulculado'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              widget.onSave(controller.text);
            },
          ),
        ],
      ),
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 200,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Wrap(
                        children: widget.itens.map(
                          (e) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  final cursorPos = controller.selection.start;
                                  if (cursorPos < 0) {
                                    return;
                                  }

                                  final newText = "data['${e.name}']";

                                  // Inserir o texto na posição do cursor
                                  final updatedText = controller.text
                                      .replaceRange(
                                          cursorPos, cursorPos, newText);

                                  // Atualizar o texto do controlador
                                  controller.text = updatedText;

                                  // Mover o cursor para o final do texto inserido
                                  controller.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                        offset: cursorPos + newText.length),
                                  );

                                  updatePreview(controller.text);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "data['${e.name}'] -> ${e.type}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: SizedBox(
                    child: TextField(
                      minLines: 200,
                      maxLines: null,
                      controller: controller,
                      decoration: const InputDecoration(
                        labelText: 'expression',
                        border: OutlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: updatePreview,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: TextField(
                scrollPhysics: const AlwaysScrollableScrollPhysics(),
                scrollController: ScrollController(),
                controller: previewController,
                style: const TextStyle(),
                minLines: 200,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Resultado',
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                scribbleEnabled: false,
                readOnly: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updatePreview(String value) {
    previewController.text = '''
expression: data => {
$value
}
''';
  }
}
