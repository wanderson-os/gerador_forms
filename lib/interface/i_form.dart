// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract interface class IForm {
  final int id;
  final String name;
  final List<int> assayIds;
  final int? controlGap;
  final String? sgqInfo;

  IForm({
    required this.id,
    required this.name,
    required this.assayIds,
    this.controlGap,
    this.sgqInfo,
  });
}

abstract class FormField {
  String get tipo => runtimeType.toString();
  final String id;
  final String name;
  final String label;
  final int? serviceId;
  FormField copyWith();
  String? expression;

  FormField({
    required this.id,
    required this.name,
    required this.label,
    this.expression,
    this.serviceId,
  });
}

enum FormInputFieldType { text, textarea }

enum FieldInputType { static, read, calculated, others }

class FormInputField extends FormField {
  final FormInputFieldType type;
  final FieldInputType fieldType;

  FormInputField({
    required super.id,
    required super.name,
    required super.label,
    required this.type,
    required this.fieldType,
    super.serviceId,
    super.expression,
  });

  @override
  String toString() {
    String result = '''\n    { 
      id: '$id',
      name: '$name',
      label: '$label',
      type: '${type.name}',
      fieldType: '${fieldType.name}',
    ''';
    if (serviceId != null) {
      result += '  serviceId: $serviceId,\n';
    }
    if (expression != null && fieldType == FieldInputType.calculated) {
      result += '  expression: data => {\n$expression\n      },\n';
    }

    result += '''
      validate: value => {
        if (value.toString().trim() === '') {
          return 'Campo obrigatório'
        }
      }
    },''';
    return result;
  }

  @override
  FormInputField copyWith({
    FormInputFieldType? type,
    FieldInputType? fieldType,
    String? id,
    String? name,
    String? label,
    int? serviceId,
    String? Function()? expression,
  }) {
    return FormInputField(
      type: type ?? this.type,
      fieldType: fieldType ?? this.fieldType,
      id: id ?? this.id,
      name: name ?? this.name,
      label: label ?? this.label,
      expression: expression == null ? this.expression : expression(),
    );
  }
}

enum FieldNumberType { static, read, others }

class FormNumberField extends FormField {
  final FieldNumberType fieldType;
  final double? min;
  final double? max;
  final double? step;
  FormNumberField({
    required super.id,
    required super.name,
    required super.label,
    required this.min,
    required this.max,
    required this.step,
    required this.fieldType,
    super.serviceId,
    super.expression,
  });

  @override
  String toString() {
    String result = '''    {
      id: '$id',
      name: '$name',
      label: '$label',
      type: 'number',
      fieldType: '${fieldType.name}',
    ''';
    if (serviceId != null) {
      result += '  serviceId: $serviceId,\n';
    }
    if (expression != null && fieldType == FieldInputType.calculated) {
      result += '  expression: data => {\n$expression\n      },\n';
    }
    result += '''
  validate: value => {
        if (value.toString().trim() === '') {
          return 'Campo obrigatório'
        }
      },
''';
    if (min != null) {
      result += '      min: $min,\n';
    }
    if (max != null) {
      result += '      max: $max,\n';
    }
    if (step != null) {
      result += '      step: $step,\n';
    }
    result += '''\n    },''';
    return result;
  }

  @override
  FormField copyWith({
    FieldNumberType? fieldType,
    double? min,
    double? max,
    double? step,
    String? id,
    String? name,
    String? label,
    int? serviceId,
    String? Function()? expression,
  }) {
    return FormNumberField(
      fieldType: fieldType ?? this.fieldType,
      min: min ?? this.min,
      max: max ?? this.max,
      step: step ?? this.step,
      id: id ?? this.id,
      name: name ?? this.name,
      label: label ?? this.label,
      expression: expression == null ? this.expression : expression(),
    );
  }
}

enum FieldSelectedType { static, read, others }

enum ItemType { string, object }

class FormSelectedField extends FormField {
  final List itens;
  final FieldSelectedType fieldType;
  final ItemType? itemType;

  FormSelectedField({
    required super.id,
    required super.name,
    required super.label,
    required this.itens,
    required this.fieldType,
    this.itemType,
    super.serviceId,
    super.expression,
  });

  @override
  String toString() {
    String result = '''    {
      id: '$id',
      name: '$name',
      label: '$label',
      type: 'select',
      fieldType: '${fieldType.name}',''';
    if (serviceId != null) {
      result += '  serviceId: $serviceId,\n';
    }

    if (itemType != null) {
      String resultList = '';
      if (itemType == ItemType.object) {
        resultList =
            '[\n       ${itens.map((option) => "{ value: '${option['value']}', label: '${option['label']}' },\n").join(',\n      ')}       ]';
      } else {
        resultList =
            '[\n      ${itens.map((option) => "'$option'").join(',\n       ')} \n      ]';
      }
      if (itens.isNotEmpty) {
        result += '\n      itens:\n      $resultList,\n';
      }
    }
    // if (expression != null && fieldType == FieldInputType.calculated) {
    //   result += '\n      expression: data => {\n$expression\n      },';
    // }

    result += '''
      \n      validate: value => {
        if (value.toString().trim() === '') {
          return 'Campo obrigatório'
        }
      }\n    },''';
    return result;
  }

  @override
  FormField copyWith({
    FieldSelectedType? fieldType,
    List? itens,
    ItemType? itemType,
    String? id,
    String? name,
    String? label,
    int? serviceId,
    String? Function()? expression,
  }) {
    return FormSelectedField(
      fieldType: fieldType ?? this.fieldType,
      itens: itens ?? this.itens,
      itemType: itemType ?? this.itemType,
      id: id ?? this.id,
      name: name ?? this.name,
      label: label ?? this.label,
      expression: expression == null ? this.expression : expression(),
    );
  }
}

enum FormFieldType {
  selection('Seleção', 'FormSelectedField'),
  text('Texto', 'FormInputField'),
  number('Número', 'FormNumberField');

  final String name;
  final String label;

  const FormFieldType(this.label, this.name);
}
