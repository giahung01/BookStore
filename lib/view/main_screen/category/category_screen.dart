import 'package:flutter/material.dart';
import 'package:week_2/data/instance.dart';
import 'package:week_2/view/main_screen/category/list_category_books.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Scaffold(
      body: Container(
        color: BookStoreColor.greyBackground(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListCategoryBooks(
                                    category: BookCategoryEnum.trinhTham.value,
                                  )));
                    },
                    child: SizedBox(
                      width: 120,
                      height: 130,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Image(
                                image: NetworkImage("https://salt.tikicdn.com/cache/750x750/ts/product/3d/c0/0d/fdff094c9f9ee5b3a5b88b9fb471e3b1.jpg.webp"),
                                fit: BoxFit.contain,
                                height: 60,
                                width: 60,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  BookCategoryEnum.trinhTham.value,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListCategoryBooks(
                                    category: BookCategoryEnum.vanHoc.value,
                                  )));
                    },
                    child: SizedBox(
                      width: 120,
                      height: 130,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Image(
                                image: NetworkImage("https://salt.tikicdn.com/cache/750x750/ts/product/5e/18/24/2a6154ba08df6ce6161c13f4303fa19e.jpg.webp"),
                                fit: BoxFit.contain,
                                height: 60,
                                width: 60,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  BookCategoryEnum.vanHoc.value,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListCategoryBooks(
                                    category: BookCategoryEnum.sachTuDuy.value,
                                  )));
                    },
                    child: SizedBox(
                      width: 120,
                      height: 130,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Image(
                                image: NetworkImage("https://salt.tikicdn.com/cache/750x750/ts/product/7c/e3/95/dae5605536e6c8b9bd8073e6482b0335.jpg.webp"),
                                fit: BoxFit.contain,
                                height: 60,
                                width: 60,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  BookCategoryEnum.sachTuDuy.value,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListCategoryBooks(
                                      category: BookCategoryEnum.tamLy.value,
                                    )));
                      },
                      child: SizedBox(
                        width: 120,
                        height: 130,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Image(
                                  image: NetworkImage("https://salt.tikicdn.com/cache/750x750/ts/product/8f/d5/8f/cccac7a0cf0851b0d3d401a243e27a23.png.webp"),
                                  fit: BoxFit.contain,
                                  height: 60,
                                  width: 60,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    BookCategoryEnum.tamLy.value,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListCategoryBooks(
                                      category:
                                          BookCategoryEnum.tonGiaoTamLinh.value,
                                    )));
                      },
                      child: SizedBox(
                        width: 120,
                        height: 130,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Image(
                                  image: NetworkImage("https://salt.tikicdn.com/cache/750x750/ts/product/37/ee/9d/fda3088df9dde40c113b584616ae1b76.jpg.webp"),
                                  fit: BoxFit.contain,
                                  height: 60,
                                  width: 60,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    BookCategoryEnum.tonGiaoTamLinh.value,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListCategoryBooks(
                                      category: BookCategoryEnum.taiChinh.value,
                                    )));
                      },
                      child: SizedBox(
                        width: 120,
                        height: 130,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Image(
                                  image: NetworkImage("https://salt.tikicdn.com/cache/750x750/ts/product/c2/3a/64/feedafb39c7bc93f49277bef45f618d4.jpg.webp"),
                                  fit: BoxFit.contain,
                                  height: 60,
                                  width: 60,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    BookCategoryEnum.taiChinh.value,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListCategoryBooks(
                                      category:
                                          BookCategoryEnum.hocTiengAnh.value,
                                    )));
                      },
                      child: SizedBox(
                        width: 120,
                        height: 130,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Image(
                                  image: NetworkImage("https://salt.tikicdn.com/cache/750x750/ts/product/da/3f/bb/a81df6a04efd34c4d51c42816b222f08.jpg.webp"),
                                  fit: BoxFit.contain,
                                  height: 60,
                                  width: 60,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    BookCategoryEnum.hocTiengAnh.value,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListCategoryBooks(
                                      category:
                                          BookCategoryEnum.truyenTranh.value,
                                    )));
                      },
                      child: SizedBox(
                        width: 120,
                        height: 130,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Image(
                                  image: NetworkImage("https://salt.tikicdn.com/cache/750x750/ts/product/31/1f/56/11457e44fc59af28be5053ab1c1ad7fb.jpg.webp"),
                                  fit: BoxFit.contain,
                                  height: 60,
                                  width: 60,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    BookCategoryEnum.truyenTranh.value,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListCategoryBooks(
                                      category:
                                          BookCategoryEnum.kienThucBachKhoa.value,
                                    )));
                      },
                      child: SizedBox(
                        width: 120,
                        height: 130,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Image(
                                  image: NetworkImage("https://salt.tikicdn.com/cache/750x750/ts/product/67/77/6e/915e36b7629c4792218f19b57a8868e4.jpg.webp"),
                                  fit: BoxFit.contain,
                                  height: 60,
                                  width: 60,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    BookCategoryEnum.kienThucBachKhoa.value,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
