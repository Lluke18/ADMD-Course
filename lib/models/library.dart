
import 'library_item.dart';
//import 'user.dart';

class Library {
    final List<LibraryItem> items;


    Library({required this.items});

    void addItem(LibraryItem item){
        items.add(item);
    }

    bool borrowItem(LibraryItem item){
         if(item.borrower != null){
            return false;
        }
        else{
            return true;
        }
    }

    void returnItem(LibraryItem item){
        if (!borrowItem(item)){
            item.borrower = null;
            item.dueDate = null; 
        }
        else print("it hasn't been borrowed");
    }

}