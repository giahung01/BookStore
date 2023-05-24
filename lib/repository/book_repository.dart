import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week_2/data/model/favourite_book.dart';

import '../data/model/book.dart';

abstract class BookRepository {
  Future<Book> getBook(String id);
  Future<Book> getBookByName(String name);
  Future<List<Book>> getBookList();
  void soldBook(String bookId);
  void updateAverageRating(String bookId);
  Stream<List<DocumentSnapshot>> getBestSellingBooks();
  void addBook(Book book);
  void updateBook(Book book);
  void addFavouriteBook(String bookId);
  void deleteFavouriteBook(String bookId);
  void deleteBook(String bookId);
  Future<List<FavouriteBook>> getFavouriteBookList();
  Future<List<String>> getBookNameList();
}