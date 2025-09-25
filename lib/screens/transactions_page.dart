import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'package:intl/intl.dart'; // for formatting dates

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
      "date": DateTime.now().millisecondsSinceEpoch, // ✅ save as int
    });

    _titleController.clear();
    _amountController.clear();
    await _loadTransactions();
  }

  String _formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
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

              return ListTile(
                title: Text(txn['title']),
                subtitle: Text(_formatDate(txn['date'])), // ✅ use formatted date
                trailing: Text("₹${txn['amount']}"),
              );
            },
          ),
        ),
      ],
    );
  }
}
