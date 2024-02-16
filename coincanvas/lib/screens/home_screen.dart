import 'package:coincanvas/configs/custom_colors.dart';
import 'package:coincanvas/repositories/book_respository.dart';
import 'package:coincanvas/widgets/home_screen/add_new_book_screen.dart';
import 'package:coincanvas/widgets/home_screen/book_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.oliveColor,
        foregroundColor: Colors.black,
        title: const Text(
          'Books',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<BookRepository>(context, listen: false)
                  .fetchNoteList();
              print(
                  Provider.of<BookRepository>(context, listen: false).bookList);
            },
            icon: const Icon(Icons.print),
          ),
          // This button is used to navigate to AddEntryScreen
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNewBookScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: const BookListWidget(),
      ),
    );
  }
}
