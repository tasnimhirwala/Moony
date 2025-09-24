import 'package:flutter/material.dart';
import 'database_helper.dart';

void main() {
  runApp(const MoonyApp());
}

class MoonyApp extends StatelessWidget {
  const MoonyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moony - Personal Finance',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    TransactionsPage(),
    BudgetsPage(),
    SavingsPage(),
  ];

  final List<String> _titles = ["Transactions", "Budgets", "Savings"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_currentIndex])),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
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
        ],
      ),
    );
  }
}

// ==================== Transactions Page ====================

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  List<Map<String, dynamic>> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final data = await DatabaseHelper().getTransactions();
    setState(() {
      _transactions = data;
    });
  }

  Future<void> _addTransaction() async {
    if (_titleController.text.isEmpty || _amountController.text.isEmpty) return;

    await DatabaseHelper().insertTransaction({
      "title": _titleController.text,
      "amount": double.tryParse(_amountController.text) ?? 0.0,
      "date": DateTime.now().toIso8601String(),
    });

    _titleController.clear();
    _amountController.clear();
    await _loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Transaction Title"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Amount"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _addTransaction,
                child: const Text("Add Transaction"),
              ),
            ],
          ),
        ),
        Expanded(
          child: _transactions.isEmpty
              ? const Center(child: Text("No transactions yet."))
              : ListView.builder(
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              final txn = _transactions[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(txn['title']),
                  subtitle: Text(txn['date'] ?? ""),
                  trailing: Text("₹${txn['amount']}"),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ==================== Budgets Page ====================

class BudgetsPage extends StatefulWidget {
  const BudgetsPage({super.key});

  @override
  State<BudgetsPage> createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();

  List<Map<String, dynamic>> _budgets = [];

  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  Future<void> _loadBudgets() async {
    final data = await DatabaseHelper().getBudgets();
    setState(() {
      _budgets = data;
    });
  }

  Future<void> _addBudget() async {
    if (_categoryController.text.isEmpty || _limitController.text.isEmpty) return;

    await DatabaseHelper().insertBudget({
      "category": _categoryController.text,
      "limitAmount": double.tryParse(_limitController.text) ?? 0.0,
    });

    _categoryController.clear();
    _limitController.clear();
    await _loadBudgets();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: "Budget Category"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _limitController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Limit Amount"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _addBudget,
                child: const Text("Add Budget"),
              ),
            ],
          ),
        ),
        Expanded(
          child: _budgets.isEmpty
              ? const Center(child: Text("No budgets yet."))
              : ListView.builder(
            itemCount: _budgets.length,
            itemBuilder: (context, index) {
              final budget = _budgets[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(budget['category']),
                  trailing: Text("₹${budget['limitAmount']}"),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ==================== Savings Page ====================

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  List<Map<String, dynamic>> _savings = [];

  @override
  void initState() {
    super.initState();
    _loadSavings();
  }

  Future<void> _loadSavings() async {
    final data = await DatabaseHelper().getSavings();
    setState(() {
      _savings = data;
    });
  }

  Future<void> _addSaving() async {
    if (_goalController.text.isEmpty || _amountController.text.isEmpty) return;

    await DatabaseHelper().insertSaving({
      "goal": _goalController.text,
      "amount": double.tryParse(_amountController.text) ?? 0.0,
    });

    _goalController.clear();
    _amountController.clear();
    await _loadSavings();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                controller: _goalController,
                decoration: const InputDecoration(labelText: "Saving Goal"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Amount"),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _addSaving,
                child: const Text("Add Saving"),
              ),
            ],
          ),
        ),
        Expanded(
          child: _savings.isEmpty
              ? const Center(child: Text("No savings yet."))
              : ListView.builder(
            itemCount: _savings.length,
            itemBuilder: (context, index) {
              final saving = _savings[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(saving['goal']),
                  trailing: Text("₹${saving['amount']}"),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
