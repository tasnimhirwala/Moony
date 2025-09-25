import 'package:flutter/material.dart';
import '../database/database_helper.dart';

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
              final amount = (saving['amount'] as num).toStringAsFixed(2); // ✅ Proper formatting
              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(saving['goal']),
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
