import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/gradient_background.dart';
import '../services/supabase_service.dart';
import 'package:intl/intl.dart';

class HomeUi extends StatefulWidget {
  const HomeUi({super.key});

  @override
  State<HomeUi> createState() => _HomeUiState();
}

class _HomeUiState extends State<HomeUi> {
  double totalIncome = 0;
  double totalExpense = 0;

  List<Map<String, dynamic>> allHistory = [];

  final formatCurrency = NumberFormat("#,##0.00", "en_US");
  final formatDate = DateFormat("dd/MM/yyyy");

  Future<void> loadData() async {
    final incomes = await SupabaseService.fetch('income');
    final expenses = await SupabaseService.fetch('expense');

    double incomeSum = 0;
    double expenseSum = 0;

    for (var item in incomes) {
      incomeSum += (item["amount"] as num).toDouble();
    }

    for (var item in expenses) {
      expenseSum += (item["amount"] as num).toDouble();
    }

    final merged = [
      ...incomes.map((e) => {...e, "type": "income"}),
      ...expenses.map((e) => {...e, "type": "expense"}),
    ];

    merged.sort(
        (a, b) => (b["created_at"] ?? "").compareTo(a["created_at"] ?? ""));

    setState(() {
      totalIncome = incomeSum;
      totalExpense = expenseSum;
      allHistory = merged;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final balance = totalIncome - totalExpense;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Home",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(248, 8, 17, 60),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total Balance",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      formatCurrency.format(balance),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSummaryCard("Income", totalIncome, Colors.green),
                  _buildSummaryCard("Expense", totalExpense, Colors.red),
                ],
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "History",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: allHistory.isEmpty
                    ? const Center(
                        child: Text(
                          "No data",
                          style: TextStyle(color: Colors.white60),
                        ),
                      )
                    : ListView.builder(
                        itemCount: allHistory.length,
                        itemBuilder: (context, index) {
                          final item = allHistory[index];
                          final isIncome = item["type"] == "income";

                          final date = item["created_at"] != null
                              ? DateTime.tryParse(item["created_at"])
                              : null;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      isIncome
                                          ? Icons.arrow_downward
                                          : Icons.arrow_upward,
                                      color:
                                          isIncome ? Colors.green : Colors.red,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        item["title"],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    Text(
                                      "${isIncome ? '+' : '-'}${item["amount"]}",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 5),

                                /// 🔥 เปลี่ยนจาก note → date
                                Text(
                                  date != null ? formatDate.format(date) : "-",
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      ),
    );
  }

  Widget _buildSummaryCard(String title, double amount, Color color) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(248, 8, 17, 60),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 8),
          Text(
            formatCurrency.format(amount),
            style: TextStyle(color: color, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
