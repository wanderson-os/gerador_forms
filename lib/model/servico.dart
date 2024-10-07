// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:gerador_forms/model/item_data.dart';

class Servico extends ItemData {
  int id;
  String name;

  Servico({
    required this.id,
    required this.name,
  });

  Servico copyWith({
    int? id,
    String? name,
  }) {
    return Servico(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Servico.fromMap(Map<String, dynamic> map) {
    final id = int.tryParse(map['id'].toString()) ?? -1;
    return Servico(
      id: id,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Servico.fromJson(String source) =>
      Servico.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => name;

  @override
  bool operator ==(covariant Servico other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  getDataValue() {
    return id;
  }

  @override
  String filterString() {
    return 'name:$name.id:$id.';
  }
}
