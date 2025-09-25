import 'package:flutter/material.dart';
import '../database/database_helper.dart';

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
              final amount = (budget['limitAmount'] as num).toStringAsFixed(2); // ✅ Format nicely
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(budget['category']),
                  trailing: Text("₹$amount"),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
