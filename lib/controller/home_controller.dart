import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gerador_forms/interface/i_form.dart' as f;
import 'package:gerador_forms/model/form_model.dart';
import 'package:gerador_forms/model/servico.dart';
import 'package:uuid/uuid.dart';

class HomeController {
  List<Servico> servicos = [];
  final List<FormModel> _forms = [];
  final List<FormModel> _formsFiltered = [];
  final List<({String name, Color color})> fields = List.unmodifiable([
    (
      name: 'Texto',
      color: Colors.green,
    ),
    (
      name: 'Número',
      color: Colors.blue,
    ),
    (
      name: 'Seleção',
      color: Colors.orange,
    )
  ]);

  FormModel? formModel;
  String path = '';
  Future<void> uploadFile() async {
    final file = await FilePickerWindows().pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (file != null) {
      final path = file.files.single.path;
      if (path == null) {
        return;
      }
      this.path = path;
      final fileExcel = await File(path).readAsBytes();
      final excel = Excel.decodeBytes(fileExcel).sheets.values.first;
      servicos = excel.rows.map(
        (e) {
          return Servico.fromMap(
            {
              'id': e[0]?.value.toString(),
              'name': e[1]?.value.toString(),
            },
          );
        },
      ).toList()
        ..removeWhere((element) => element.id == -1);
    }
  }

  void addNewForm() {
    formModel = FormModel(
      id: const Uuid().v4().hashCode,
      name: 'Formulário ${_forms.length + 1}',
      filename: 'form_${_forms.length + 1}',
      sgqInfo: '',
      services: [],
      fields: [],
    );
    _forms.add(formModel!);
    _formsFiltered.add(formModel!);
  }

  void addNewField(f.FormFieldType type) {
    if (formModel == null) {
      return;
    }
    final name = 'field_${formModel!.fields.length + 1}';
    f.FormField field;

    if (type == f.FormFieldType.text) {
      field = f.FormInputField(
        id: 'field_${formModel!.fields.length + 1}',
        name: name,
        label: 'Campo ${formModel!.fields.length + 1}',
        type: f.FormInputFieldType.text,
        fieldType: f.FieldInputType.static,
      );
    } else if (type == f.FormFieldType.number) {
      field = f.FormNumberField(
        min: 0,
        max: 100,
        step: 1,
        id: name,
        name: name,
        label: 'Campo ${formModel!.fields.length + 1}',
        fieldType: f.FieldNumberType.static,
      );
    } else {
      field = f.FormSelectedField(
        itens: [],
        id: name,
        name: name,
        label: 'Campo ${formModel!.fields.length + 1}',
        fieldType: f.FieldSelectedType.static,
      );
    }

    formModel!.fields.add(field);
  }

  Future<void> generateClassTs() async {
    if (formModel == null) {
      return;
    }

    await File('lib/model/form_${formModel!.filename.toLowerCase()}.ts')
        .writeAsString(formModel!.generateFile());
  }

  void filterForms(String value) {
    if (value.isEmpty) {
      _formsFiltered.clear();
      _formsFiltered.addAll(_forms);
      return;
    }

    _formsFiltered.clear();
    _formsFiltered.addAll(
      _forms.where(
        (element) => element.name.toLowerCase().contains(value.toLowerCase()),
      ),
    );
  }

  List<FormModel> getForms() => List.unmodifiable(_formsFiltered);

  void removeForm(FormModel form) {
    formModel = formModel?.id == form.id ? null : formModel;
    _forms.removeWhere((f) => f.id == form.id);
    _formsFiltered.removeWhere((f) => f.id == form.id);
  }
}
