// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:phone_lap/helpers/size_config.dart';
import 'package:phone_lap/models/analysis.dart';
import 'package:phone_lap/providers/analyzer.dart';
import 'package:phone_lap/providers/cart.dart';
import 'package:phone_lap/providers/order.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartScreen extends StatelessWidget {
  static String routname = '/Cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final user = Provider.of<AnalyzerProvider>(context).analyzer!;
    final cost = Provider.of<Orders>(context)
        .servicePrice(user.address.split('-').first, cart.items)
        .toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.mycart),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (cart.itemCount == 0)
                Center(
                    child: Text(
                  AppLocalizations.of(context)!.noitemscart,
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                  textAlign: TextAlign.center,
                ))
              else
                ...getList(cart),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(),
                    Text(
                      AppLocalizations.of(context)!.deliverdetails,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 3,
                margin: const EdgeInsets.all(15),
                child: Container(
                  //   height: 120,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${user.name}',
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: getProportionateScreenWidth(10),
                            ),
                            Text(
                              AppLocalizations.of(context)!.name,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ].reversed.toList(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${user.address}',
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: getProportionateScreenWidth(10),
                            ),
                            Text(
                              AppLocalizations.of(context)!.adress,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ].reversed.toList(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${user.phone}',
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: getProportionateScreenWidth(10),
                            ),
                            Text(
                              AppLocalizations.of(context)!.phoneNumber,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ].reversed.toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 0,
                margin: const EdgeInsets.all(15),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.totalprice,
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).primaryColor),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${cart.totalAmount.floorToDouble() + double.parse(cost)}',
                              maxLines: 1,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.le,
                              maxLines: 1,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Text(AppLocalizations.of(context)!.servicecost + cost),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OrderButton(cart: cart),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<CartItem> getList(Cart cart) {
    return List.generate(
        cart.itemCount,
        (index) => CartItem(
              id: cart.items[index].id,
              title: cart.items[index].analysis.name,
              productId: cart.items[index].id,
              quantity: 1,
              imgUrl: cart.items[index].passportImageUrl,
              analysis: cart.items[index].analysis,
            ));
  }
}

class OrderButton extends StatefulWidget {
  final Cart cart;

  const OrderButton({
    required this.cart,
  });

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final userAuth = Provider.of<AnalyzerProvider>(context).analyzer;
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
      ),
      child: TextButton(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Text(
                AppLocalizations.of(context)!.sendorder,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
        onPressed: (widget.cart.itemCount < 0 || _isLoading)
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                final items = widget.cart.items;
                var total = 0.00;
                for (var item in widget.cart.items) {
                  total += double.parse(item.analysis.price);
                }
                widget.cart.totalAmount;
                final orderItem = OrderItem(
                    analysis: widget.cart.items,
                    user: userAuth!,
                    isDeliverd: 'no',
                    dateTime: DateTime.now(),
                    totalPrice: widget.cart.totalAmount);
                await Provider.of<Orders>(context, listen: false)
                    .sendOrder(orderItem);
                widget.cart.clear();
                Navigator.pop(context);
                //   items,
                //   widget.cart.totalAmount,
                //   userAuth.phoneNumber,
                //   userAuth.name,
                //   userAuth.address,
                // );
                // String item = "";
                // items.forEach((e) {
                //   item += "${e.title} (${e.quantity}),";
                // });
                //  // var user = {
                //   UserFields.productsName: item,
                //   UserFields.userName: userAuth.name,
                //   UserFields.userPhoneNumber: "+2${userAuth.phoneNumber}",
                //   UserFields.userAdress: userAuth.address,
                //   UserFields.date: DateTime.now().toString(),
                //   UserFields.totalPrice: widget.cart.totalAmount
                // };
                // UserSheetApi.insert(user);
                // Navigator.pushReplacementNamed(context, ConfirmScreen.routname);

                setState(() {
                  _isLoading = false;
                });
              },
        style: ButtonStyle(
            textStyle: MaterialStateProperty.resolveWith((states) => TextStyle(
                  color: Theme.of(context).primaryColor,
                ))),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final Analysis? analysis;
  final String? id;
  final String? productId;

  final int? quantity;
  final String? title;
  final String? imgUrl;

  const CartItem(
      {this.id,
      this.productId,
      this.quantity,
      this.title,
      this.imgUrl,
      this.analysis});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 150,
                height: 50,
                child: Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'ج.م',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor)),
                    TextSpan(
                        text: analysis!.price,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor)),
                  ])),
                  IconButton(
                      // onPressed: () {
                      //   Provider.of<Cart>(context, listen: false)
                      //       .removeSingleItem(productId);
                      onPressed: () {
                        Provider.of<Cart>(context, listen: false)
                            .removeItem(analysis!);
                      },
                      icon: const Icon(Icons.delete)),
                ],
              ),
              if (imgUrl != null)
                Image.network(
                  imgUrl!,
                  height: getProportionateScreenHeight(200),
                  width: getProportionateScreenWidth(300),
                  fit: BoxFit.contain,
                ),
            ],
          ),
        ));
  }
}
