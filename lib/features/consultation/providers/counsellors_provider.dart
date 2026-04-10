import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/counsellor_model.dart';
import '../../../data/dummy_counsellors.dart';

final counsellorsProvider = FutureProvider<List<CounsellorModel>>((ref) async {
  try {
    final response = await http.get(Uri.parse('https://www.mindspacebd.com/api/professionals'));
    
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      if (decodedData['success'] == true && decodedData['data'] != null) {
        final List<dynamic> dataList = decodedData['data'];
        return dataList.map((json) => CounsellorModel.fromJson(json)).toList();
      }
    }
    // Fallback to dummy data if format fails but request went through
    return DummyCounsellors.all;
  } catch (e) {
    // Fallback to dummy data on network error
    return DummyCounsellors.all;
  }
});
