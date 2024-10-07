// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gerador_forms/interface/i_form.dart';
import 'package:gerador_forms/model/servico.dart';

class FormModel {
  int id;
  String name;
  String filename;
  String sgqInfo;
  List<Servico> services;
  List<FormField> fields;
  DateTime? createdAt;
  bool isEditing = false;

  String generateFile() {
    String teste = '''
import type { IForm } from '../../pages/forms'
import { parse } from 'date-fns'

const form: IForm = {
  id: $id,
  name: '$name',
  assayIds: [${services.map((e) => e.id).toList().join(',')}],
  sgqInfo: '$sgqInfo',
  form: [${fields.map((e) => e.toString()).join('\n')}\n  ]
}
  ''';

    return teste += '''\nexport default form''';
  }

  FormModel({
    required this.id,
    required this.name,
    required this.sgqInfo,
    required this.services,
    required this.fields,
    this.createdAt,
    required this.filename,
  });

  FormModel copyWith({
    int? id,
    String? name,
    String? fileName,
    String? sgqInfo,
    List<Servico>? services,
    List<FormField>? fields,
    DateTime? Function()? createdAt,
  }) {
    return FormModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sgqInfo: sgqInfo ?? this.sgqInfo,
      services: services ?? this.services.map((e) => e.copyWith()).toList(),
      fields: fields ?? this.fields.map((e) => e.copyWith()).toList(),
      createdAt: createdAt == null ? this.createdAt : createdAt(),
      filename: filename,
    );
  }
}
