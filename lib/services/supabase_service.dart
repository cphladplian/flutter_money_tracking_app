import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final client = Supabase.instance.client;

  static Future<List<Map<String, dynamic>>> fetch(String type) async {
                                          //ดึงข้อมูล    

    try {
  //ดึงข้อมูล
      final res = await client
          .from('transactions')
          .select()
          .eq('type', type)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(res);
    } catch (e) {   //เช็คข้อผิดพลาด
      print(e);    //แสดงข้อผิดพลาด
      return [];  //คืนค่าว่าง
    }
  }

  //เพิ่มข้อมูล
  static Future<void> add({
    required String title,
    required String note,
    required double amount,
    required String type,
  }) async {
    try {
      await client.from('transactions').insert({
        'title': title,
        'note': note,
        'amount': amount,
        'type': type,
      });
    } catch (e) {
      print(e);
    }
  }
}
