import 'package:flutter/material.dart';
import 'Api/movies.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo TEST API',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor:  Colors.brown[100], // Update background color here
      ),
      home: const MyHomePage(title: 'Flutter Demo TEST'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.brown[100], // Update background color here
      ),
      home: PostsApi(),
    );
  }
}
