abstract class ItemData {
  dynamic getDataValue();
}

class SimpleValue extends ItemData {
  final dynamic value;
  final String label;
  SimpleValue(this.value, {this.label = ''});

  @override
  dynamic getDataValue() {
    return value;
  }

  @override
  String toString() {
    return label.isEmpty ? value.toString() : label;
  }
}
