import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gerador_forms/interface/i_form.dart' as f;
import 'package:gerador_forms/interface/i_form.dart';
import 'package:gerador_forms/model/form_model.dart';
import 'package:gerador_forms/model/item_data.dart';
import 'package:gerador_forms/model/servico.dart';
import 'package:gerador_forms/widgets/assay_ids_page.dart';
import 'package:gerador_forms/widgets/calculate_field_text.dart';
import 'package:gerador_forms/widgets/custom_select_item.dart';

class ManageForm extends StatefulWidget {
  final FormModel formModel;
  final List<Servico> services;
  final List<({String name, Color color})> itens;
  final Function(FormModel form) onSave;

  const ManageForm({
    super.key,
    required this.formModel,
    required this.services,
    required this.onSave,
    required this.itens,
  });

  @override
  State<ManageForm> createState() => _ManageFormState();
}

class _ManageFormState extends State<ManageForm> {
  late final FormModel form;
  late final ValueKey key;
  f.FormFieldType? fieldType;
  @override
  void initState() {
    form = widget.formModel;
    key = ValueKey(form.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: form.name,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      form.name = value;
                      form.isEditing = true;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StatefulBuilder(
                    builder: (_, setStateBuilder) => Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            initialValue: form.filename,
                            decoration: const InputDecoration(
                              labelText: 'Nome do arquivo',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              form.filename = value;
                              form.isEditing = true;
                              setStateBuilder(() {});
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Nome do arquivo final',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              form.filename.isEmpty
                                  ? ''
                                  : 'form_${form.filename}.ts',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    child: Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            key: ValueKey(form.id),
                            initialValue: form.sgqInfo,
                            decoration: const InputDecoration(
                              labelText: 'SGQ Info',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              form.sgqInfo = value;
                              form.isEditing = true;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (
                                  context,
                                ) {
                                  return AlertDialog(
                                    content: SizedBox(
                                      width: 600,
                                      height: 400,
                                      child: AssayIdsPage(
                                        itens: widget.services,
                                        selecteds: form.services,
                                        onConfirmSelection: (servicos) {
                                          form.services = servicos;
                                          form.isEditing = true;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Assay Ids',
                                suffixIcon: Icon(Icons.touch_app_outlined),
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                form.services.length.toString(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Flexible(
                        child: Card(
                          child: ListTile(
                            onTap: () async {
                              final type = await showDialog<SimpleValue>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Tipo de campo'),
                                  content: Container(
                                    constraints: const BoxConstraints(
                                      maxHeight: 300,
                                      maxWidth: 300,
                                    ),
                                    width: 300,
                                    child: CustomSelectItemModal<SimpleValue>(
                                      itens: f.FormFieldType.values
                                          .map(
                                            (e) =>
                                                SimpleValue(e, label: e.name),
                                          )
                                          .toList(),
                                      label: 'Tipo de campo',
                                      initialvalue: null,
                                      onSelectedItem: (value) {
                                        if (value == null) {
                                          return;
                                        }
                                        Navigator.of(context).pop(value);
                                      },
                                    ),
                                  ),
                                ),
                              );

                              if (type == null) {
                                return;
                              }
                              setState(
                                () {
                                  addNewField(type.value);
                                },
                              );
                            },
                            title: Text(
                              'Campos: ${form.fields.length}',
                            ),
                            subtitle:
                                const Text('Adicione campos ao formulário'),
                            trailing: const Icon(
                              Icons.new_label_outlined,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              final item = widget.itens[index];
                              return SizedBox(
                                width: 120,
                                child: ListTile(
                                  minVerticalPadding: 0,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    item.name,
                                  ),
                                  leading: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      overlayColor: WidgetStateProperty.all(
                                        Colors.transparent,
                                      ),
                                      onTap: () {
                                        setState(
                                          () {
                                            if (fieldType == null) {
                                              fieldType = f.FormFieldType.values
                                                  .firstWhere(
                                                (element) =>
                                                    element.label == item.name,
                                              );
                                            } else if (fieldType!.label ==
                                                item.name) {
                                              fieldType = null;
                                            } else {
                                              fieldType = f.FormFieldType.values
                                                  .firstWhere(
                                                (element) =>
                                                    element.label == item.name,
                                              );
                                            }
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: item.color,
                                        ),
                                        child: Visibility(
                                          visible:
                                              fieldType?.label == item.name,
                                          child: const Center(
                                            child: Icon(
                                              Icons.circle,
                                              size: 12,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * .4,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  Wrap(
                    children: (fieldType == null
                            ? form.fields
                            : form.fields
                                .where((element) =>
                                    element.tipo == fieldType!.name)
                                .toList())
                        .map(
                      (field) {
                        String expression = '';
                        if (field is f.FormInputField) {
                          expression = field.expression ?? '';
                        }
                        final fieldType = switch (field.runtimeType) {
                          const (f.FormInputField) =>
                            (field as f.FormInputField).fieldType.name,
                          const (f.FormNumberField) =>
                            (field as f.FormNumberField).fieldType.name,
                          const (f.FormSelectedField) =>
                            (field as f.FormSelectedField).fieldType.name,
                          _ => ''
                        };
                        final color = field is f.FormInputField
                            ? Colors.green.withOpacity(.6)
                            : field is f.FormNumberField
                                ? Colors.blue.withOpacity(.6)
                                : Colors.orange.withOpacity(.6);
                        return SizedBox(
                          width: 300,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: color,
                                width: 2,
                              ),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              onTap: () async {
                                final newField = await editFormField(field);
                                setState(
                                  () {
                                    final index = form.fields.indexWhere(
                                      (element) => element.id == field.id,
                                    );
                                    form.fields[index] = newField;
                                    if (newField is FormInputField) {
                                      expression = newField.expression ?? '';
                                    }
                                  },
                                );
                              },
                              title: Text(
                                'Nome: ${field.name}',
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: Visibility(
                                visible: fieldType
                                    .toLowerCase()
                                    .contains('calculated'),
                                child: IconButton(
                                  onPressed: () async {
                                    await generateCalculateFieldText(
                                      field,
                                    );
                                    setState(() {});
                                  },
                                  icon: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border:
                                          Border.all(color: color, width: 2),
                                    ),
                                    child: Icon(
                                      Icons.flash_on_outlined,
                                      color: expression.isNotEmpty
                                          ? Colors.green
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Tipo: ${field.tipo}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'ID: ${field.id}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Label: ${field.label}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Field Type: $fieldType',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              trailing: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      final canDelete =
                                          await _canDelete(context, field);

                                      if (canDelete ?? false) {
                                        setState(
                                          () {
                                            form.fields.removeWhere(
                                              (element) =>
                                                  element.id == field.id,
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> generateCalculateFieldText(f.FormField field) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: 800,
          height: 700,
          child: CalculateFieldText(
            field: field,
            itens: form.fields
                .map(
                  (e) => (name: e.name, type: 'String'),
                )
                .toList(),
            onSave: (expression) {
              field.expression = expression;
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );

    return '';
  }

  Future<f.FormField> editFormField(
    f.FormField field,
  ) async {
    field = await showDetail(field);

    //return field;

    // f.FormField? newField = field.copyWith();
    // if (field is f.FormInputField) {
    //   newField = await showDialog<f.FormField>(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (context) {
    //       final nameEC = TextEditingController(text: field.name);
    //       final idEC = TextEditingController(text: field.id);
    //       final labelEC = TextEditingController(text: field.label);
    //       f.FieldInputType fieldType = field.fieldType;
    //       return PopScope(
    //         onPopInvokedWithResult: (_, __) {
    //           nameEC.dispose();
    //           idEC.dispose();
    //           labelEC.dispose();
    //         },
    //         child: AlertDialog(
    //           actions: [
    //             TextButton(
    //               onPressed: () {
    //                 Navigator.of(context).pop(field);
    //               },
    //               child: const Text('Cancelar'),
    //             ),
    //             TextButton(
    //               onPressed: () {
    //                 Navigator.of(context).pop(
    //                   field.copyWith(
    //                     name: nameEC.text,
    //                     id: idEC.text,
    //                     label: labelEC.text,
    //                     fieldType: fieldType,
    //                   ),
    //                 );
    //               },
    //               child: const Text('Salvar'),
    //             ),
    //           ],
    //           content: Container(
    //             constraints: const BoxConstraints(
    //               maxHeight: 600,
    //               maxWidth: 500,
    //             ),
    //             child: SingleChildScrollView(
    //               scrollDirection: Axis.vertical,
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                   TextFormField(
    //                     controller: nameEC,
    //                     decoration: const InputDecoration(
    //                       labelText: 'Nome',
    //                       border: OutlineInputBorder(),
    //                     ),
    //                   ),
    //                   const SizedBox(
    //                     height: 10,
    //                   ),
    //                   TextFormField(
    //                     controller: idEC,
    //                     decoration: const InputDecoration(
    //                       labelText: 'ID',
    //                       border: OutlineInputBorder(),
    //                     ),
    //                   ),
    //                   const SizedBox(
    //                     height: 10,
    //                   ),
    //                   TextFormField(
    //                     controller: labelEC,
    //                     decoration: const InputDecoration(
    //                       labelText: 'Label',
    //                       border: OutlineInputBorder(),
    //                     ),
    //                   ),
    //                   const SizedBox(
    //                     height: 10,
    //                   ),
    //                   Flexible(
    //                     child: SingleChildScrollView(
    //                       child: StatefulBuilder(
    //                         builder: (context, setStateBuilder) {
    //                           return Row(
    //                             children: f.FieldInputType.values
    //                                 .map(
    //                                   (e) => Container(
    //                                     constraints: const BoxConstraints(
    //                                       maxHeight: 100,
    //                                     ),
    //                                     child: Row(
    //                                       children: [
    //                                         Radio(
    //                                           groupValue: fieldType,
    //                                           value: e,
    //                                           onChanged: (value) {
    //                                             fieldType = e;
    //                                             setState(() {});
    //                                             setStateBuilder(() {});
    //                                           },
    //                                         ),
    //                                         Text(e.name),
    //                                       ],
    //                                     ),
    //                                   ),
    //                                 )
    //                                 .toList(),
    //                           );
    //                         },
    //                       ),
    //                     ),
    //                   )
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //   );
    //   log('Edit FormInputField');
    //   print(field.name);
    // } else if (field is f.FormNumberField) {
    //   log('Edit FormNumberField');
    //   await _editNumberField();
    // }

    // if (newField == null) {
    //   return field;
    // }
    // return newField;

    return field;
  }

  Future<void> _editNumberField() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit FormNumberField'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Min',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Max',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Step',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _canDelete(BuildContext context, f.FormField? field) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Desenja excluir o campo\n${field?.label} ?',
              textAlign: TextAlign.start,
            ),
            const Text(
              'Essa ação não poderá ser desfeita.',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop(
                false,
              );
            },
          ),
          CupertinoDialogAction(
            child: const Text('Confirmar'),
            onPressed: () {
              Navigator.of(context).pop(
                true,
              );
            },
          ),
        ],
      ),
    );
  }

  void addNewField(f.FormFieldType type) {
    final name = 'field_${form.fields.length + 1}';
    f.FormField field;

    if (type == f.FormFieldType.text) {
      field = FormInputField(
        id: 'field_${form.fields.length + 1}',
        name: name,
        label: 'Campo ${form.fields.length + 1}',
        type: FormInputFieldType.text,
        fieldType: FieldInputType.static,
      );
    } else if (type == FormFieldType.number) {
      field = FormNumberField(
        min: 0,
        max: 100,
        step: 1,
        id: name,
        name: name,
        label: 'Campo ${form.fields.length + 1}',
        fieldType: FieldNumberType.static,
      );
    } else {
      field = FormSelectedField(
        itens: [],
        id: name,
        name: name,
        label: 'Campo ${form.fields.length + 1}',
        fieldType: FieldSelectedType.static,
      );
    }

    form.fields.add(field);
  }

  Future<f.FormField> showDetail(f.FormField field) async {
    final nameEC = TextEditingController(text: field.name);
    final idEC = TextEditingController(text: field.id);
    final labelEC = TextEditingController(text: field.label);

    final stepEC = TextEditingController();
    final minEC = TextEditingController();
    final maxEC = TextEditingController();

    late f.FieldInputType fieldInputType;
    late f.FieldNumberType fieldNumberType;
    f.FormField? newFormField;

    if (field is FormInputField) {
      fieldInputType = field.fieldType;
    } else if (field is FormNumberField) {
      fieldNumberType = field.fieldType;
      stepEC.text = field.step?.toString() ?? '';
      minEC.text = field.min?.toString() ?? '';
      maxEC.text = field.max?.toString() ?? '';
    }
    newFormField = await showDialog<f.FormField>(
      barrierDismissible: false,
      context: context,
      builder: (context) => PopScope(
        onPopInvokedWithResult: (_, __) {
          nameEC.dispose();
          idEC.dispose();
          labelEC.dispose();
        },
        child: AlertDialog(
          actionsAlignment: MainAxisAlignment.start,
          title: Text('Detalhes do campo ${field.name}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(field);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                late f.FormField formField;

                if (field is f.FormInputField) {
                  formField = field.copyWith(
                    name: nameEC.text,
                    id: idEC.text,
                    label: labelEC.text,
                    fieldType: fieldInputType,
                  );
                } else if (field is f.FormNumberField) {
                  formField = field.copyWith(
                    name: nameEC.text,
                    id: idEC.text,
                    label: labelEC.text,
                    fieldType: fieldNumberType,
                  );
                }

                Navigator.of(context).pop(formField);
              },
              child: const Text('Salvar'),
            ),
          ],
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameEC,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: idEC,
                  decoration: const InputDecoration(
                    labelText: 'ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: labelEC,
                  decoration: const InputDecoration(
                    labelText: 'Label',
                    border: OutlineInputBorder(),
                  ),
                ),
                Builder(
                  builder: (context) {
                    if (field is f.FormNumberField) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: minEC,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*')),
                            ],
                            decoration: const InputDecoration(
                              labelText: 'MIN',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: maxEC,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*')),
                            ],
                            decoration: const InputDecoration(
                              labelText: 'MAX',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*')),
                            ],
                            keyboardType: TextInputType.number,
                            controller: stepEC,
                            decoration: const InputDecoration(
                              labelText: 'STEP',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: Builder(
                    builder: (context) {
                      if (field is f.FormInputField) {
                        return SingleChildScrollView(
                          child: StatefulBuilder(
                            builder: (context, setStateBuilder) {
                              return Row(
                                children: f.FieldInputType.values
                                    .map(
                                      (e) => Container(
                                        constraints: const BoxConstraints(
                                          maxHeight: 100,
                                        ),
                                        child: Row(
                                          children: [
                                            Radio(
                                              groupValue: fieldInputType,
                                              value: e,
                                              onChanged: (value) {
                                                fieldInputType = e;
                                                setState(() {});
                                                setStateBuilder(() {});
                                              },
                                            ),
                                            Text(e.name),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                )
              ],
            ),
          ),
          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     Text('ID: ${field.id}'),
          //     Text('Nome: ${field.name}'),
          //     Text('Label: ${field.label}'),
          //     Text('Tipo: ${field.tipo}'),
          //     if (field is FormInputField)
          //       Text('Field Type: ${field.fieldType.name}'),
          //     if (field is FormNumberField)
          //       Text('Field Type: ${field.fieldType.name}'),
          //     if (field is FormSelectedField)
          //       Text('Field Type: ${field.fieldType.name}'),
          //   ],
          // ),
        ),
      ),
    );

    return newFormField ?? field;
  }
}
