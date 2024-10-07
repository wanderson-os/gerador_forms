import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gerador_forms/controller/home_controller.dart';
import 'package:gerador_forms/interface/i_form.dart' as form;
import 'package:gerador_forms/widgets/manage_form.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeController = HomeController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('aaa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(
                () {
                  homeController.addNewForm();
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              log('Refresh');
            },
          ),
          IconButton(
            icon: const Icon(Icons.file_copy_outlined),
            onPressed: () async {
              await homeController.generateClassTs();
            },
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: ListTile(
              title: const Text('Arquivo de serviços'),
              subtitle: Text(homeController.path),
              trailing: const Icon(Icons.attach_file_rounded),
              onTap: () async {
                await homeController.uploadFile();
                setState(() {});
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Flexible(
            child: Row(
              children: [
                Flexible(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Pesquisar form',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          homeController.filterForms(value);
                          setState(() {});
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        child: SuperListView.builder(
                          itemBuilder: (context, index) {
                            final form = homeController.getForms()[index];
                            return Card(
                              color: homeController.formModel?.id == form.id
                                  ? Colors.blue.shade900
                                  : null,
                              child: ListTile(
                                onTap: () {
                                  homeController.formModel = form;
                                  setState(() {});
                                },
                                title: Text(form.name),
                                subtitle: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Id: ${form.id}',
                                    ),
                                    Text(
                                      'Serviços:[${form.services.map((e) => e.id).join(', ')}]',
                                    ),
                                    Visibility(
                                      visible: form.createdAt != null,
                                      child: Text(
                                        form.createdAt?.toIso8601String() ?? '',
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    homeController.removeForm(
                                      form,
                                    );
                                    setState(() {});
                                  },
                                ),
                                leading: Icon(
                                  Icons.circle_rounded,
                                  color: form.isEditing
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),
                            );
                          },
                          itemCount: homeController.getForms().length,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  flex: 2,
                  child: Builder(
                    builder: (context) {
                      if (homeController.formModel == null) {
                        return const SizedBox();
                      }
                      return Visibility(
                        visible: homeController.formModel != null,
                        child: ManageForm(
                          key: ValueKey(homeController.formModel!.id),
                          formModel: homeController.formModel!,
                          services: homeController.servicos,
                          onSave: (formModel) {
                            homeController.formModel = formModel;
                            setState(() {});
                          },
                          itens: homeController.fields,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<form.FormField> editFormField(
    form.FormField field,
  ) async {
    form.FormField? newField = field.copyWith();
    if (field is form.FormInputField) {
      newField = await showDialog<form.FormField>(
        context: context,
        builder: (context) => AlertDialog(
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(field);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(
                  field.copyWith(
                    name: 'Novo Nome',
                    id: 'Novo ID',
                    label: 'Novo Label',
                  ),
                );
              },
              child: const Text('Salvar'),
            ),
          ],
          content: Container(
            constraints: const BoxConstraints(
              maxHeight: 500,
              maxWidth: 300,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: field.name,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: field.id,
                  decoration: const InputDecoration(
                    labelText: 'ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: field.label,
                  decoration: const InputDecoration(
                    labelText: 'Label',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      log('Edit FormInputField');
      print(field.name);
    } else if (field is form.FormNumberField) {
      log('Edit FormNumberField');
    }

    if (newField == null) {
      return field;
    }
    return newField;
  }
}
