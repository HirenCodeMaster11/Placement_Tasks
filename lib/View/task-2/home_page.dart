import 'package:flutter/material.dart';
import 'package:placement_tasks/View/task-2/login_page-2.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../modal/task-2/userModal-2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  List<User> users = [];
  User? currentUser;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
    loadAllUsers();
  }

  Future<void> loadAllUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentUserData = prefs.getString('userData');
    List<String>? savedUsersData = prefs.getStringList('allUsers');

    if (savedUsersData != null) {
      setState(() {
        users = savedUsersData
            .map((userJson) => User.fromJson(jsonDecode(userJson)))
            .toList();
      });
    }

    if (currentUserData != null) {
      setState(() {
        currentUser = User.fromJson(jsonDecode(currentUserData));
        if (!users.any((user) => user.id == currentUser!.id)) {
          users.add(currentUser!);
          saveAllUsers();
        }
      });
    }
  }

  Future<void> saveAllUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> userJsonList =
    users.map((user) => jsonEncode(user.toJson())).toList();
    await prefs.setStringList('allUsers', userJsonList);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        foregroundColor: Colors.white,
        leading: const Icon(Icons.account_circle_sharp),
        title: const Text(
          "Welcome",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: FadeTransition(
            opacity: _fadeInAnimation,
            child: users.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Column(
              children: [
                if (currentUser != null)
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(currentUser!.image),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "${currentUser!.firstName} ${currentUser!.lastName}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentUser!.email,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                const Divider(color: Colors.white70),
                const SizedBox(height: 16),
                ...users.map((user) => Card(
                  color: Colors.blueGrey.shade800,
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(user.image),
                    ),
                    title: Text(
                      "${user.firstName} ${user.lastName}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      user.email,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                    onTap: () {

                    },
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
