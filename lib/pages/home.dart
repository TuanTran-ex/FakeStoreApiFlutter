import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:storeproject/configs/constants.dart';
import 'package:storeproject/models/product.dart';
import 'package:storeproject/pages/cart.dart';
import 'package:storeproject/pages/product_description.dart';
import 'package:storeproject/providers/cart_provider.dart';
import 'package:storeproject/providers/product_provider.dart';
import 'package:storeproject/widgets/search.dart';
// import 'package:storeproject/models/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<Product> list;
  late Future<List<Product>> _listProducts;
  late Future<List<dynamic>> _listCategory;
  late List<String> _listTitle;
  late String _category;
  late ProductProvider productProvider;
  late CartProvider cartProvider;
  List<Product> _cart = [];
  List<String> sortDropdown = [
    CustomConstants.ALPHABET_LOW_TO_HIGH,
    CustomConstants.ALPHABET_HIGHT_TO_LOW,
    CustomConstants.PRICE_LOW_TO_HIGH,
    CustomConstants.PRICE_HIGH_TO_LOW,
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    productProvider = Provider.of<ProductProvider>(context, listen: false);
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    _listCategory = productProvider.getListCategory();
    _listProducts = productProvider.getList("");
    _listTitle = productProvider.listTitle;
    _cart = cartProvider.listProduct;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: blockCartIcon(context),
        body: Container(
          decoration: BoxDecoration(color: Color.fromARGB(255, 245, 245, 245)),
          child: Column(children: [
            // blockCartIcon(),
            blockCategorySlide(),
            blockSortIcon(),
            blockListProduct()
          ]),
        ),
      ),
    );
  }

  // blockCartIcon() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //       ElevatedButton(onPressed: () {}, child: const Icon(Icons.pages)),
  //       ElevatedButton(onPressed: () {}, child: const Icon(Icons.pages))
  //     ]),
  //   );
  // }
  blockCartIcon(BuildContext context) {
    return AppBar(title: Text("FakeAPI Store"), actions: <Widget>[
      IconButton(
        onPressed: () async {
          // method to show the search bar
          final searchResult = await showSearch(
              context: context,
              // delegate to customize the search bar
              delegate: CustomSearchDelegate(searchTerms: _listTitle));
          Provider.of<ProductProvider>(context, listen: false)
              .getListSearch(searchResult);
        },
        icon: const Icon(Icons.search),
      ),
      Padding(
          padding: const EdgeInsets.all(10.0),
          child: Consumer<CartProvider>(builder: (context, data, _) {
            return Container(
                height: 150.0,
                width: 30.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            CartPage(listProduct: data.listProduct)));
                  },
                  child: Stack(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        onPressed: null,
                      ),
                      data.listProduct.length == 0
                          ? Container()
                          : Positioned(
                              child: Stack(
                              children: <Widget>[
                                Icon(Icons.brightness_1,
                                    size: 20.0, color: Colors.green[800]),
                                Positioned(
                                    top: 4.0,
                                    right: 6.0,
                                    child: Center(
                                      child: Text(
                                        data.listProduct.length.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ],
                            )),
                    ],
                  ),
                ));
          })),
    ]);
  }

  blockCategorySlide() {
    return Consumer<ProductProvider>(builder: (context, data, _) {
      return data.categories.length == 0
          ? const CircularProgressIndicator()
          : Container(
              width: double.infinity,
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    Container(
                      margin: const EdgeInsets.only(right: 15),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // _category = "";
                            _listProducts = productProvider.getList("");
                          });
                        },
                        style: ButtonStyle(
                            alignment: Alignment.center,
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.fromLTRB(30, 10, 30, 10))),
                        child: const Text("All"),
                      ),
                    ),
                    ...data.categories.map(((e) {
                      return Container(
                        margin: const EdgeInsets.only(right: 15),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              // _category = e;
                              _listProducts = productProvider.getList(e);
                            });
                          },
                          style: ButtonStyle(
                              alignment: Alignment.center,
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.fromLTRB(30, 10, 30, 10))),
                          child: Text(e),
                        ),
                      );
                    }))
                  ])),
            );
    });
  }

  blockSortIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DropdownButton<String>(
          underline: Container(),
          // dropdownColor: Colors.blue,
          icon: Icon(Icons.sort, color: Colors.deepPurple),
          items: sortDropdown.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            Provider.of<ProductProvider>(context, listen: false)
                .sortListProduct(value);
          },
        ),
      ],
    );
  }

  blockListProduct() {
    // var productProvider = Provider.of<ProductProvider>(context);
    // productProvider.getList(_category);
    return Consumer<ProductProvider>(builder: (context, data, _) {
      return data.list.isEmpty
          ? const Text(
              "No products available",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          : Expanded(
              child: GridView.count(
                childAspectRatio: 2 / 3,
                padding: const EdgeInsets.all(10),
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                crossAxisCount: 2,
                children: [
                  ...data.list.map((e) {
                    return productItem(e);
                  })
                ],
              ),
            );
    });
  }

  productItem(Product product) {
    return Container(
      width: MediaQuery.of(context).size.width * 5 / 10 - 30,
      // height: 700,
      padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 69, 69, 69).withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),

      child: Column(
          // direction: Axis.horizontal,
          // alignment: WrapAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductDescriptionPage(
                              // id: product.id ?? -1,
                              // title: product.title,
                              // description: product.description ?? "",
                              // price: product.price ?? 0,
                              // image: product.image ?? "",
                              // rating: product.rating ?? {"rate": 0, "count": 0},
                              product: product,
                            )));
              },
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.network(
                    product.image ?? "",
                    fit: BoxFit.scaleDown,
                    height: 90,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    child: Text(
                      product.title,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    // height: 40,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${product.price.toString()}\$",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: product.rating?['rate'] ?? 0,
                            minRating: 0.1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                            itemSize: 14,
                          ),
                          Text(
                            "${product.rating?['count'] ?? 0.0} ratings",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  cartProvider.add(product, 1);
                  setState(() {
                    _cart = cartProvider.listProduct;
                  });
                },
                child: const Text(
                  'Add to cart',
                  style: TextStyle(fontSize: 12),
                ),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(10)),
                ))
          ]),
    );
  }
}
