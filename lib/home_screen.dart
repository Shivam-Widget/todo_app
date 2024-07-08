import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'db_service/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool personal = true, collage = false, office = false;
  bool suggest = false;

  TextEditingController todoController = TextEditingController();

  Stream? todoStream;

  getOnTheLoad() async {
    todoStream = await DatabaseService().getTask(personal
        ? 'Personal'
        : collage
            ? 'Collage'
            : 'Office');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  getWork() {
    return StreamBuilder(
      stream: todoStream,
      builder: (context, AsyncSnapshot snapShot) {
        return snapShot.hasData
            ? Expanded(
                child: ListView.builder(
                    itemCount: snapShot.data.docs.length,
                    itemBuilder: (ctx, i) {
                      DocumentSnapshot docSnap = snapShot.data.docs[i];
                      return CheckboxListTile(
                        value: docSnap['Yes'],
                        onChanged: (newValue) async {
                          await DatabaseService().tickMethod(
                              docSnap.id,
                              personal
                                  ? 'Personal'
                                  : collage
                                      ? 'Collage'
                                      : 'Office');
                          setState(() {
                            Future.delayed(
                                const Duration(
                                  seconds: 2,
                                ), () {
                              DatabaseService().removeMethod(
                                  docSnap.id,
                                  personal
                                      ? 'Personal'
                                      : collage
                                          ? 'Collage'
                                          : 'Office');
                            });
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: Colors.green.withOpacity(0.5),
                        title: Text(docSnap['work'], style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.7),

                        ),),
                      );
                    }),
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openBox();
        },
        backgroundColor: Colors.blueAccent.withOpacity(0.6),
        child: const Icon(
          Icons.add,
          color: Colors.white30,
          size: 35,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 17, left: 20),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.cyan.withOpacity(0.5),
                    Colors.amberAccent.withOpacity(0.4),
                    Colors.purple.withOpacity(0.3),
                    Colors.pink.withOpacity(0.2),
                    Colors.pink.withOpacity(0.5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hii,',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Shivam',
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Let's the work begins!",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      personal
                          ? Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Personal',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black.withOpacity(0.6),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                personal = true;
                                collage = false;
                                office = false;
                                await getOnTheLoad();
                                setState(() {});
                              },
                              child: const Text(
                                'Personal',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                      collage
                          ? Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Collage',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black.withOpacity(0.6),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                personal = false;
                                collage = true;
                                office = false;
                                await getOnTheLoad();
                                setState(() {});
                              },
                              child: const Text(
                                'Collage',
                                style: TextStyle(
                                  fontSize: 20,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                      office
                          ? Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Office',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black.withOpacity(0.6),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                personal = false;
                                collage = false;
                                office = true;
                                await getOnTheLoad();
                                setState(() {});
                              },
                              child: const Text(
                                'Office',
                                style: TextStyle(
                                  fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  getWork(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future openBox() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.cancel),
                    ),
                    const SizedBox(
                      width: 60,
                    ),
                    const Text(
                      'Add ToDo Task ~',
                      style: TextStyle(color: Colors.green),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Add Text'),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: TextField(
                    controller: todoController,
                    decoration:
                        const InputDecoration(hintText: 'Enter the task'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      String id = randomAlphaNumeric(10);
                      Map<String, dynamic> userTodo = {
                        'work': todoController.text,
                        'id': id,
                        'Yes': false,
                      };
                      personal
                          ? DatabaseService().addPersonalTask(userTodo, id)
                          : collage
                              ? DatabaseService().addCollageTask(userTodo, id)
                              : DatabaseService().addOfficeTask(userTodo, id);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
