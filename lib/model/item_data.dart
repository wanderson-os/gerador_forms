abstract class ItemData {
  dynamic getDataValue();
  String label;
  String filterString();
  ItemData({this.label = ''});
}

class SimpleValue extends ItemData {
  final dynamic value;

  SimpleValue(this.value, {super.label = ''});

  @override
  dynamic getDataValue() {
    return value;
  }

  @override
  String filterString() {
    return value.toString();
  }

  @override
  String toString() {
    return label.isEmpty ? value.toString() : label;
  }
}
