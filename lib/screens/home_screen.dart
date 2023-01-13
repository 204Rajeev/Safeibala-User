import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saf_user/screens/feed_screen.dart';
import 'package:saf_user/widgets/scroll_rows.dart';
import 'package:saf_user/models/user.dart' as model;
import '../providers/user_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/post_scroll_rows.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String greetMsg = '';

  @override
  void initState() {
    super.initState();
    addData();
    greet();
  }

  addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  void seeFeed() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FeedScreen()));
  }

  void greet() {
    if (DateTime.now().hour < 12 && DateTime.now().hour > 0) {
      greetMsg = 'Good Morning';
    } else if (DateTime.now().hour >= 12 && DateTime.now().hour <= 16) {
      greetMsg = 'Good Afternoon';
    } else {
      greetMsg = 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        drawer: const Drawer(
          backgroundColor: Color.fromARGB(210, 255, 255, 255),
          child: AppDrawer(),
        ),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(99, 64, 169, 255),
          elevation: 0,
          title: const Text(
            '',
            style: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: const [
                  Text(
                    ' Home Screen',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              Column(
                children: [
                  Row(
                    children: [
                      Text(greetMsg,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.normal)),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        user.userName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => seeFeed(),
                    child: const Text(
                      'Posts',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: seeFeed,
                    icon: const Icon(Icons.arrow_forward_ios),
                  )
                ],
              ),
              //PostScrollRows(),

              Container(
                height: 110,
                child: StreamBuilder(
                  stream:
                      FirebaseFirestore.instance.collection('Post').snapshots(),
                  builder: ((context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (ctx, index) => Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: PostScrollRows(
                                snap: snapshot.data!.docs[index].data())));
                  }),
                ),
              ),

              Row(
                children: const [
                  Text(
                    'Nearest Dumping Centers',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const ScrollRows(),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Text(
                    'News & Updates',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  SingleChildScrollView(
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          width: 60,
                          //decoration: const BoxDecoration(color: Colors.grey),
                          child: Image.asset('assets/images/AD.jpg',
                              fit: BoxFit.fitHeight),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Expanded(
                          child: Text(
                            'Monday Offer 500 rs per 10 kg Electronic waste!',
                            softWrap: false,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          width: 60,
                          child: Image.asset('assets/images/glass.jpg',
                              fit: BoxFit.fitHeight),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Expanded(
                          child: Text(
                            'Cashback of Rs.50 on 25Kg Glass Waste.....',
                            softWrap: false,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          width: 60,
                          child: Image.asset('assets/images/cleann.jpg',
                              fit: BoxFit.fitHeight),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text('Join Ghatikia Clean Up Day on 30 Nov'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
