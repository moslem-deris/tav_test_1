import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tavtestproject1/features/product/data/models/product_model.dart';
import 'package:tavtestproject1/features/product/presentation/bloc/bloc.dart';
import 'package:tavtestproject1/route_generator.dart';

class ProductShopItem extends StatefulWidget {
  final ProductModel _productModel;

  ProductShopItem(this._productModel) : assert(_productModel != null);

  @override
  _ProductShopItemState createState() => _ProductShopItemState(_productModel);
}

class _ProductShopItemState extends State<ProductShopItem> {
  ProductBloc _productBloc;
  ProductModel _productModel;

  _ProductShopItemState(this._productModel);

  @override
  void initState() {
    super.initState();
    _productBloc = BlocProvider.of<ProductBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductBloc, ProductState>(
      bloc: _productBloc,
      listenWhen: (oldState, newState) => newState is ProductLoadedState,
      listener: (context, state) {
        ProductModel newProductModel =
            (state as ProductLoadedState).productModel;
        if (newProductModel.id == _productModel.id)
          setState(() {
            _productModel = newProductModel;
          });
      },
      builder: (context, state) {
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/product/shop/details',
                  arguments: ProductDetailsArgs(_productModel));
            },
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: _productModel.imagePath == null
                          ? Image.asset(
                              "assets/images/default_product.png",
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : Image.file(
                              File(_productModel.imagePath),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                    ),
                    Container(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              _productModel.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: "Geometria",
                                  fontSize: 16,
                                  color: Color.fromRGBO(78, 74, 71, 1),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            _productModel.price.toString() + "\$",
                            style: TextStyle(
                                fontFamily: "Geometria",
                                fontSize: 22,
                                color: Color.fromRGBO(78, 74, 71, 1),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(228, 227, 225, 0.6),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: IconButton(
                      icon: Icon(
                        _productModel.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 16,
                        color: Color.fromRGBO(96, 91, 85, 1),
                      ),
                      onPressed: () {
                        _productModel.isFavorite = !_productModel.isFavorite;
                        _productBloc.add(EditProductEvent(_productModel));
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
