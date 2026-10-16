import 'library_item.dart';
class Magazine extends LibraryItem{
  final int? issueNumber;
  final String? publisher;

  Magazine({required super.title, super.author, super.publishDate, super.borrower, super.dueDate, this.issueNumber, this.publisher});
}