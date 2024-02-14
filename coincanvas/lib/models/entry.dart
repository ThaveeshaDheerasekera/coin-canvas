import 'package:coincanvas/configs/constants.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

class Entry {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime createdAt;
  final Category category;
  final Type type;
  final PaymentMethod paymentMethod;

  Entry({
    required this.title,
    required this.description,
    required this.amount,
    required this.createdAt,
    required this.category,
    required this.type,
    required this.paymentMethod,
  }) : id = uuid.v4();

  String get formattedDate {
    return DateFormat('dd-MMM-yyyy | HH:mm:ss').format(createdAt);
  }
}
