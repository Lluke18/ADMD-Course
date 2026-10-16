import 'library_item.dart';
class Book extends LibraryItem{
  final int? pageCount;
  final String? isbn;

  Book({required super.title, super.author, super.publishDate, super.borrower, super.dueDate, this.pageCount, this.isbn});
      

}