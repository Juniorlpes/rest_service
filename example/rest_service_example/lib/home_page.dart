import 'package:flutter/material.dart';
import 'package:rest_service_example/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController homeController = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            homeController.ipModel?.toString() ?? '',
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            onPressed: () async {
              await homeController.getIPData();
              setState(() {});
            },
            child: const Text('Get Ip Data'),
          )
        ],
      ),
    );
  }
}
