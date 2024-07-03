import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_ecom/models/productmodel.dart';
import 'package:riverpod_ecom/widgets/dotindicator.dart';

class ProductdetailsScreen extends StatefulWidget {
  const ProductdetailsScreen({Key? key, required this.product})
      : super(key: key);
  final ProductModel product;

  @override
  State<ProductdetailsScreen> createState() => _ProductdetailsScreenState();
}

class _ProductdetailsScreenState extends State<ProductdetailsScreen> {
  dynamic currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider.builder(
                itemCount: widget.product.images.length,
                itemBuilder: (context, index, realIndex) {
                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(widget.product.images[index]),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 15.0,
                        right: 20.0,
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0)),
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(LucideIcons.heart),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...List.generate(
                                widget.product.images.length,
                                (index) => WidDotIndicator(
                                  isActive: index == currentIndex,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                options: CarouselOptions(
                  viewportFraction: 1,
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                )),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              widget.product.category.name,
              style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            const SizedBox(
              height: 3.0,
            ),
            Text(
              widget.product.title,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 3.0,
            ),
            Text(
              "₹${widget.product.price.toString()}/-",
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              widget.product.description,
              style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.black87),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 15.0, right: 10.0, left: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width / 2.2,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.black,
                    iconColor: Colors.white,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Add to cart  ",
                          style: TextStyle(color: Colors.white)),
                      Icon(LucideIcons.shopping_cart)
                    ],
                  )),
            ),
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width / 2.2,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.black,
                    iconColor: Colors.white,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Buy Now  ", style: TextStyle(color: Colors.white)),
                      Icon(LucideIcons.shopping_bag)
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
