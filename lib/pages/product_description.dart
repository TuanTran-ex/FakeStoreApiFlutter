import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:storeproject/models/product.dart';
import 'package:storeproject/widgets/search.dart';

import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import 'cart.dart';

class ProductDescriptionPage extends StatelessWidget {
  const ProductDescriptionPage({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: blockCartIcon(context),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Column(children: [
          Image.network(product.image ?? "",
              fit: BoxFit.scaleDown, height: 200),
          SizedBox(height: 20),
          buildTitle(product.title, product.price, product.rating),
          SizedBox(height: 20),
          buildDescription(product.description),
          SizedBox(height: 20),
          // buildPrice(product.price),
          buildButton(context, product.price)
        ]),
      )),
    );
  }

  blockCartIcon(BuildContext context) {
    return AppBar(actions: <Widget>[
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

  buildTitle(title, price, rating) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          RatingBar.builder(
            initialRating: rating['rate'] ?? 0,
            minRating: 0.1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {},
            itemSize: 20,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "${rating['count'] ?? 0.0} ratings",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ]),
        SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  buildDescription(description) {
    return Expanded(
      child: SingleChildScrollView(
        child: Text(
          description,
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 17),
        ),
      ),
    );
  }

  buildPrice(price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "${price.toString()}\$",
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  buildButton(BuildContext context, price) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "${price.toString()}\$",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false).add(product, 1);
            },
            child: Text('Add to cart'),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40), elevation: 5),
          ),
        ),
      ],
    );
  }
}
