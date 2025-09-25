import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'transactions_page.dart';
import 'budget_screen.dart';
import 'saving_screen.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool _isProfileComplete = false;

  final List<Widget> _pages = const [
    TransactionsPage(),
    BudgetsPage(),
    SavingsPage(),
    ProfilePage(),
  ];

  final List<String> _titles = ["Transactions", "Budgets", "Savings", "Profile"];

  @override
  void initState() {
    super.initState();
    _checkProfile();
  }

  Future<void> _checkProfile() async {
    final profile = await DatabaseHelper().getProfile();
    setState(() {
      _isProfileComplete = profile != null;
      _currentIndex = _isProfileComplete ? 0 : 3; // If no profile, go to ProfilePage
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: Colors.black, // Dark AppBar
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, // Make nav bar dark
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          // Force profile completion first
          if (!_isProfileComplete && index != 3) return;

          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Budgets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings),
            label: 'Savings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
