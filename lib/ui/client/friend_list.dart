import 'package:flutter/material.dart';

class OnlineBuddiesPage extends StatefulWidget {
  @override
  _OnlineBuddiesPageState createState() => _OnlineBuddiesPageState();
}

class _OnlineBuddiesPageState extends State<OnlineBuddiesPage> {
  List<String> onlineFriends = [
    'Friend 1',
    'Friend 2',
    'Friend 3',
    // Add more friends as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            // borderRadius: BorderRadius.circular(25), // Adding border radius
            border: Border(
                top: BorderSide(width: 1, color: Colors.black),
                left: BorderSide(width: 1, color: Colors.black))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                'Buddies Online', // Heading
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: onlineFriends.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(0,2,0,6),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey, width: 2))),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://res.cloudinary.com/demo/image/twitter/1330457336.jpg'),
                      ),
                      title: Text(onlineFriends[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.call),
                        color: Colors.greenAccent,
                        onPressed: () {},
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
