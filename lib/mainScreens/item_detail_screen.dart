import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:usuarios_app/assistantMethods/assistant_methods.dart';
import 'package:usuarios_app/models/items.dart';
import 'package:usuarios_app/widgets/app_bar.dart';
import 'package:number_inc_dec/number_inc_dec.dart';


class ItemDetailsScreen extends StatefulWidget
{
  final Items? model;
  ItemDetailsScreen({this.model});

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}




class _ItemDetailsScreenState extends State<ItemDetailsScreen>
{
  TextEditingController counterTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: MyAppBar(sellerUID: widget.model!.sellerUID),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex:3,
            child:(
                Image.network(widget.model!.thumbnailUrl.toString())
            )
          ),

          Flexible(
            flex: 2,
            child: NumberInputPrefabbed.roundedButtons(
              controller: counterTextEditingController,
              incDecBgColor: Colors.amber,
              min: 1,
              max: 9,
              initialValue: 1,
              buttonArrangement: ButtonArrangement.incRightDecLeft,
            ),
          ),

          Flexible(
            flex: 2,
            child: Text(
              widget.model!.title.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),

          Flexible(
            flex: 2,
            child: Text(
              widget.model!.longDescription.toString(),
              textAlign: TextAlign.justify,
              style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            ),
          ),

          Flexible(
            flex: 2,
            child: Text(
              widget.model!.price.toString() + " L",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),

          const SizedBox(height: 10,),

          Center(
            child: InkWell(
              onTap: ()
              {
                int itemCounter = int.parse(counterTextEditingController.text);

                List<String> separateItemIDsList = separateItemIDs();

                //1.check if item exist already in cart
                separateItemIDsList.contains(widget.model!.itemID)
                    ? Fluttertoast.showToast(msg: "Este Item ya esta en el carrito.")
                    :
                    //2.add to cart
                    addItemToCart(widget.model!.itemID, context, itemCounter);
              },
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.cyan,
                        Colors.amber,
                      ],
                      begin:  FractionalOffset(0.0, 0.0),
                      end:  FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    )
                ),
                width: MediaQuery.of(context).size.width - 13,
                height: 50,
                child: const Center(
                  child: Text(
                    "Agregar al carrito",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
