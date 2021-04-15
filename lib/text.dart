import 'package:carousel_slider/carousel_slider.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'util.dart';

class Book {
  bool _isNew;
  bool _isFavorite;
  String _title;
  String _thumbnailPath;
  String _detailPath;
  String _releaseDate;

  Book() {
    _isNew = false;
    _isFavorite = false;
    _title = '';
    _thumbnailPath = '';
    _detailPath = '';
    _releaseDate = '2020/01/01';
  }

  /* 本がまだ読まれたことのない状態であるかどうかを返す */
  bool isNew() {
    return _isNew;
  }

  /* 本がお気に入りされているかどうかを返す */
  bool isFavorite() {
    return _isFavorite;
  }

  /* 本のサムネイルを格納したパスを設定する */
  void setThumbnailPath(String path) {
    _thumbnailPath = path;
  }

  /* 本のサムネイルを格納したパスを返す */
  String getThumbnailPath() {
    return _thumbnailPath;
  }

  /* 本の内容を格納したパスを設定する */
  void setDetailPath(String path) {
    _detailPath = path;
  }

  /* 本の内容を格納したパスを返す */
  String getDetailPath() {
    return _detailPath;
  }

  /* 本のタイトルを設定する */
  void setTitle(String title) {
    _title = title;
  }

  /* 本のタイトルを返す */
  String getTitle() {
    return _title;
  }

  /* 本のお気に入りボタンのアイコンを返す */
  String getButtonIcon() {
    return _isFavorite ? 'images/icon/icon_favorited.png' : 'images/icon/icon_favorite.png';
  }

  /* 本のお気に入り状態を切り替える */
  void toggleFavorite() {
    _isFavorite = _isFavorite ? false : true;
    debugPrint('toggleFavorite -> $_isFavorite');
  }

  String getReleaseDate() {
    return _releaseDate;
  }
}

class TextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(child: ChangeForm()));
  }
}

class ChangeForm extends StatefulWidget {
  @override
  _TextPageDetail createState() {
    return _TextPageDetail();
  }
}

class _TextPageDetail extends State<ChangeForm> {
  TextStyle _standardText = TextStyle(color: Colors.black, fontSize: 18.0);
  double _standardIconSize = 40.0;
  int _selectPageNumber = 1;
  int _booksCount = 0;
  List<Book> books;
  bool isFirstReload = true;

  @override
  Widget build(BuildContext context) {
    _booksCount = 34;

    if(isFirstReload) {
      books = loadBooks(_booksCount);
      isFirstReload = false;
    }

    return Container(
      padding: EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Text('検索バー', style: _standardText),
            Container(
                width: 260.0,
                height: 80.0,
                child: SearchBar(onSearch: searchBook, onItemFound: null)),
            GestureDetector(
              onTap: sortText,
              child: Row(
                children: [
                  Text('並び替え', style: TextStyle(fontSize: 15)),
                  ImageIcon(AssetImage('images/icon/icon_sort.png'),
                      size: _standardIconSize)
                ],
              ),
            )
          ],
        ),
        SpaceBox(height: MediaQuery.of(context).size.height / 60),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
                onPressed: showAll, child: Text('すべて', style: _standardText, textScaleFactor: 0.8)),
            TextButton(
                onPressed: showDownloaded,
                child: Text('ダウンロード済み', style: _standardText, textScaleFactor: 0.8)),
            TextButton(
                onPressed: showFavorites,
                child: Text('お気に入り', style: _standardText, textScaleFactor: 0.8)),
          ],
        ),
        SpaceBox(height: MediaQuery.of(context).size.height / 50),
        CarouselSlider(
            options: CarouselOptions(
                height: 600.0,
                initialPage: 0,
                viewportFraction: 1,
                enableInfiniteScroll: false
            ),
            items: getBookShelves()
        ),
      ]
      ),
    );
  }

  void sortText() {
    debugPrint('run sortText()');
  }

  void showAll() {
    debugPrint('run showAll()');
  }

  void showDownloaded() {
    debugPrint('run showDownloaded()');
  }

  void showFavorites() {
    debugPrint('run showFavorites()');
  }

  void selectPage(int pageNumber) {
    setState(() {
      _selectPageNumber = pageNumber;
    });
  }

  Future<List<Book>> searchBook(String bookName) async {}

  Color getPagerColor(int pageNumber) {
    return pageNumber == _selectPageNumber ? Colors.blueAccent : Colors.grey;
  }

  void selectBook(int bookNumber) {
    debugPrint('run selectBook(book $bookNumber)');
  }

  List<Book> loadBooks(int booksCount) {
    List<Book> _books = [];
    Book book;
    debugPrint('loadBooks');
    for(int x = 0; x < booksCount; x++) {
      book = new Book();
      book.setThumbnailPath('images/content/text/text_sample1.png');
      _books.add(book);
    }
    return _books;
  }

  List<Column> getBookShelves() {
    int pageCount = _booksCount ~/ 9;
    pageCount += _booksCount % 9 == 0 ? 0 : 1;
    List<Column> bookShelfs = [];
    Column onePageBookShelf;
    for(int x = 0; x < pageCount; x++) {
      onePageBookShelf = Column(
        children: getOnePageBookShelf(x),
      );
      bookShelfs.add(onePageBookShelf);
    }
    return bookShelfs;
  }

  List<Stack> getOnePageBookShelf(int page) {
    int pageInBooksCount = 9; // ページ内に存在する本の冊数 1 <= 9
    int lineCount = 3; //ページに何行の本棚が存在するか 1 <= 3
    int pageCount = _booksCount ~/ 9;
    pageCount += _booksCount % 9 == 0 ? 0 : 1;

    // 本棚が満たされていれば3行分Stackを生成し、3行に満たない場合はその数だけ生成する
    if((page + 1) == pageCount) { //最後のページの場合
      pageInBooksCount = _booksCount % 9;
      lineCount = pageInBooksCount ~/ 3;
      lineCount += pageInBooksCount % 3 == 0 ? 0 : 1;
    }

    List<Stack> oneLineBookShelfs = [];
    Stack oneLineBookShelf;
    for(int x = 0; x < lineCount; x++) {
      oneLineBookShelf = Stack(
        children: [
          Column(
            children: [
              SpaceBox(height: MediaQuery.of(context).size.height / 8),
              Image.asset('images/content/text/bg_bookshelf.png', fit: BoxFit.contain)
            ],
          ),
          getOneLineBooks(page * 3 + (x + 1))
        ],
      );
      oneLineBookShelfs.add(oneLineBookShelf);
    }

    return oneLineBookShelfs;
  }

  /* 1行分の本棚を生成する */
  Row getOneLineBooks(int lineNumber) { // lineNumber >= 1
    List<Stack> bookStacks = [];
    int startBookNumber = lineNumber * 3 - 2;

    // 基本的に本を3つ生成し、残りの本の数が3に満たない時は残りの数だけ生成する
    int bookMakeCount = (startBookNumber + 2) > _booksCount ? (_booksCount % 3) : 3;
    for(int i = 0; i < bookMakeCount; i++) {
      bookStacks.add(getBookStack(startBookNumber + i)); // i番目の本のStackを生成
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: bookStacks,
    );
  }

  /* 本とお気に入りボタンのStackを生成する */
  Stack getBookStack(int bookNumber) {
    return Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          getDetectorBook(bookNumber),
          getFavoriteButton(bookNumber)
        ]
    );
  }

  /* 本番号を持つタップ可能な本を生成する */
  GestureDetector getDetectorBook(int bookNumber) {
    return GestureDetector(
      onTap: () => selectBook(bookNumber),
      child: Image.asset(books[bookNumber-1].getThumbnailPath(), height: MediaQuery.of(context).size.height / 5.5),
    );
  }

  /* 本番号を持つタップ可能なお気に入りボタンを生成する */
  IconButton getFavoriteButton(int bookNumber) {
    Color buttonColor;
    return IconButton(
        icon: ImageIcon(AssetImage(books[bookNumber-1].getButtonIcon())),
        onPressed: () => updateFavoriteState(bookNumber-1),
        color: books[bookNumber-1].isFavorite() ? Colors.yellow : Colors.black,
    );
  }

  Color updateColor() {
    return Colors.yellow;
  }

  void updateFavoriteState(int bookNumber) {
    debugPrint('pressed book: $bookNumber');
    books[bookNumber].toggleFavorite();
    setState(() {});
  }

}