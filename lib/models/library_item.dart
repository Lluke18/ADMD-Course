import 'user.dart';
abstract class LibraryItem{
  final String title;
  final String? author;
  final DateTime? publishDate;
  late User? borrower;
  late DateTime? dueDate;

  LibraryItem({required this.title, this.author, this.publishDate, this.borrower, this.dueDate});


  //void setBorrower() =>
    //borrower = 

    
}