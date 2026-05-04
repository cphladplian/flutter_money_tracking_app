class AppData {
  static List<Map<String, dynamic>> incomes = [];
  static List<Map<String, dynamic>> expenses = [];

  static double get totalIncome =>
      incomes.fold(0, (sum, item) => sum + item["amount"]);
            //fold(ค่าเริ่มต้น, (ค่าเริ่มต้น, item) => ค่าเริ่มต้น + item["amount"]);

  static double get totalExpense =>
      expenses.fold(0, (sum, item) => sum + item["amount"]);

  static double get balance => totalIncome - totalExpense;
}
