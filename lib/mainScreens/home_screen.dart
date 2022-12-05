import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:usuarios_app/assistantMethods/assistant_methods.dart';
import 'package:usuarios_app/authentication/auth_screen.dart';
import 'package:usuarios_app/global/global.dart';
import 'package:usuarios_app/models/sellers.dart';
import 'package:usuarios_app/splashScreen/splash_screen.dart';
import 'package:usuarios_app/widgets/sellers_design.dart';
import 'package:usuarios_app/widgets/my_drawer.dart';
import 'package:usuarios_app/widgets/progress_bar.dart';

import '../authentication/login.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {
  final items = [
    "slider/slider/0.jpg",
    "slider/slider/1.jpg",
    "slider/slider/2.jpg",
    "slider/slider/3.jpg",
    "slider/slider/4.jpg",
    "slider/slider/5.jpg",
    "slider/slider/6.jpg",
    "slider/slider/7.jpg",
    "slider/slider/8.jpg",
    "slider/slider/9.jpg",
    "slider/slider/10.jpg",
    "slider/slider/11.jpg",
    "slider/slider/12.jpg",
    "slider/slider/13.jpg",
    "slider/slider/14.jpg",
    "slider/slider/15.jpg",
    "slider/slider/16.jpg",
    "slider/slider/17.jpg",
    "slider/slider/18.jpg",
    "slider/slider/19.jpg",
    "slider/slider/20.jpg",
    "slider/slider/21.jpg",
    "slider/slider/22.jpg",
    "slider/slider/23.jpg",
    "slider/slider/24.jpg",
    "slider/slider/25.jpg",
    "slider/slider/26.jpg",
    "slider/slider/27.jpg",
  ];

  restrictBlockedUsersFromUsingApp() async{
    await FirebaseFirestore.instance.collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .get().then((snapshot){
          if(snapshot.data()!["status"] != "approved"){
            Fluttertoast.showToast(msg: "Ha sido bloqueado.");
            firebaseAuth.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreen()));
      }else{
            clearCartNow(context);
          }
    });
  }


  @override
  void initState() {
    super.initState();

    restrictBlockedUsersFromUsingApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
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
        ),
        title: const Text(
          "iFood",
          style: TextStyle(fontSize: 45, fontFamily: "Signatra"),
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: MediaQuery.of(context).size.height * .3,
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * .3,
                    aspectRatio: 16/9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(milliseconds: 500),
                    autoPlayCurve: Curves.decelerate,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: items.map((index) {
                    return Builder(builder: (BuildContext context){
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 1.0),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                              index,
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    });
                  }).toList(),
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .snapshots(),
            builder: (context, snapshot)
            {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                  : SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 1,
                      staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                      itemBuilder: (context, index)
                      {
                        Sellers sModel = Sellers.fromJson(
                          snapshot.data!.docs[index].data()! as Map<String, dynamic>
                        );
                        //design for display sellers-cafes-restuarents
                        return SellersDesignWidget(
                          model: sModel,
                          context: context,
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
            },
          ),
        ],
      ),
    );
  }
}
