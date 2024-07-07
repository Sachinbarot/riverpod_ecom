import 'package:flutter/material.dart';
import 'package:open_document/my_files/init.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:riverpod_ecom/models/productmodel.dart';
import 'package:pdf/widgets.dart' as pw;

class GenerateinvoiceScreen extends StatefulWidget {
  const GenerateinvoiceScreen({Key? key, required this.product})
      : super(key: key);
  final ProductModel product;

  @override
  State<GenerateinvoiceScreen> createState() => _GenerateinvoiceScreenState();
}

class _GenerateinvoiceScreenState extends State<GenerateinvoiceScreen> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Create Invoice"),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Row(
              children: [
                Text(
                  "Invoice No: MYSTORE2401",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Invoice Date: ${DateTime.now().day} - ${DateTime.now().month} - ${DateTime.now().year}",
                  style: TextStyle(color: Colors.black45),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Product Detail"),
                    Divider(),
                    Text(
                      "${widget.product.title}",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16.0),
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.product.description}",
                                maxLines: 3,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "₹${widget.product.price.toString()}/-",
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          size: 20.0,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (quantity > 1) {
                                              quantity--;
                                            }
                                          });
                                        },
                                      ),
                                      Text(
                                        quantity.toString(),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          size: 20.0,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (quantity < 15) {
                                              quantity++;
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: NetworkImage(
                                    widget.product.images[0].toString()),
                                fit: BoxFit.fill,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Price Details"),
                    Divider(
                      thickness: 1.0,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Subtotal"),
                        Text(
                          "₹${widget.product.price * quantity}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("SGST(9%)"),
                        Text(
                          "₹${widget.product.price * quantity * 9 / 100}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("CGST(9%)"),
                        Text(
                          "₹${widget.product.price * quantity * 9 / 100}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Discount(10%)",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "₹${widget.product.price * quantity * 10 / 100}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "₹${(widget.product.price * quantity + widget.product.price * 18 / 100 - widget.product.price * 10 / 100).round()} ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                onPressed: () async {
                  final pdf = pw.Document();
                  pdf.addPage(pw.Page(
                    pageFormat: PdfPageFormat.a4,
                    theme: pw.ThemeData(header0: pw.TextStyle()),
                    build: (pw.Context context) {
                      return pw.Center(
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                            pw.Text("MYSTORE",
                                style: pw.TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Text("Invoice No:- #MYSTORE2024"),
                            pw.Text(
                                "Invoice Date:- ${DateTime.now().day} - ${DateTime.now().month} - ${DateTime.now().year}"),
                            pw.Divider(),
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text("Invoice TO:",
                                            style: pw.TextStyle(
                                                fontWeight:
                                                    pw.FontWeight.bold)),
                                        pw.Text("JOHN HOWELS DOW",
                                            style: pw.TextStyle(
                                                fontWeight:
                                                    pw.FontWeight.bold)),
                                        pw.Text(
                                            "5223 San Mateo Blvd NE,\n Albuquerque - 87109,New York \n United States",
                                            style:
                                                pw.TextStyle(fontSize: 12.0)),
                                        pw.Text("Phone: (505) 883-9090",
                                            style: pw.TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: pw.FontWeight.bold))
                                      ]),
                                  pw.SizedBox(width: 50.0),
                                  pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text("Invoice TO:",
                                            style: pw.TextStyle(
                                                fontWeight:
                                                    pw.FontWeight.bold)),
                                        pw.Text("JOHN HOWELS DOW",
                                            style: pw.TextStyle(
                                                fontWeight:
                                                    pw.FontWeight.bold)),
                                        pw.Text(
                                            "5223 San Mateo Blvd NE,\n Albuquerque - 87109,New York \n United States",
                                            style:
                                                pw.TextStyle(fontSize: 12.0)),
                                        pw.Text("Phone: (505) 883-9090",
                                            style: pw.TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: pw.FontWeight.bold))
                                      ])
                                ]),
                            pw.Divider(),
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Container(
                                    width: PdfPageFormat.a4.width / 2,
                                    child: pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text(
                                          "${widget.product.title}",
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              fontSize: 16.0),
                                        ),
                                        pw.Text(
                                          "${widget.product.description}",
                                          maxLines: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                  pw.Spacer(),
                                  pw.Text(
                                    "${quantity}",
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.Spacer(),
                                  pw.Text(
                                    "${widget.product.price}",
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ]),
                            // pw.Spacer(),
                            pw.Divider(
                              thickness: 1.0,
                            ),
                            pw.SizedBox(
                              height: 10.0,
                            ),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text("Subtotal"),
                                pw.Text(
                                  "${widget.product.price * quantity}",
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(
                              height: 5.0,
                            ),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text("SGST(9%)"),
                                pw.Text(
                                  "${widget.product.price * quantity * 9 / 100}",
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(
                              height: 5.0,
                            ),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text("CGST(9%)"),
                                pw.Text(
                                  "${widget.product.price * quantity * 9 / 100}",
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(
                              height: 5.0,
                            ),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  "Discount(10%)",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Text(
                                  "${widget.product.price * quantity * 10 / 100}",
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            pw.Divider(),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  "Total",
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Text(
                                  "${(widget.product.price * quantity + widget.product.price * 18 / 100 - widget.product.price * 10 / 100).round()} ",
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ]));
                    },
                  ));
                  pdf.save();
                  final Directory dir = await getApplicationSupportDirectory();
                  final file = File("${dir.path}/invoice.pdf");
                  await file.writeAsBytes(await pdf.save());

                  await OpenFile.open(file.path);

                  print(file);
                },
                child: Text(
                  "Generate",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: Colors.white),
                ))
          ]),
        )));
  }
}
