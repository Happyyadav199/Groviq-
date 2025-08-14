import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class WooApi {
  String get _base => '${AppConfig.baseUrl}/wp-json/wc/v3';

  Map<String, String> get _authQ => {
    'consumer_key': AppConfig.key,
    'consumer_secret': AppConfig.secret,
  };

  Future<List<dynamic>> _get(String path, [Map<String, String>? q]) async {
    final uri = Uri.parse('$_base$path').replace(queryParameters: {..._authQ, ...(q ?? {})});
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('GET $path failed: ${res.statusCode} ${res.body}');
    }
    final body = jsonDecode(res.body);
    return body is List ? body : [];
  }

  Future<Map<String, dynamic>> _post(String path, Map body) async {
    final uri = Uri.parse('$_base$path').replace(queryParameters: _authQ);
    final res = await http.post(uri, headers: {'Content-Type':'application/json'}, body: jsonEncode(body));
    if (res.statusCode != 201) {
      throw Exception('POST $path failed: ${res.statusCode} ${res.body}');
    }
    return jsonDecode(res.body);
  }

  Future<List<dynamic>> categories({int perPage = 50}) async {
    return _get('/products/categories', {'per_page': '$perPage', 'hide_empty': 'true'});
  }

  Future<List<dynamic>> products({String? category, int perPage = 20, int page = 1, String? search}) async {
    final q = {'per_page': '$perPage', 'page': '$page'};
    if (category != null && category.isNotEmpty) q['category'] = category;
    if (search != null && search.isNotEmpty) q['search'] = search;
    return _get('/products', q);
  }

  Future<Map<String, dynamic>> createOrder({
    required List<Map<String, dynamic>> lineItems,
    required Map<String, dynamic> billing,
    required Map<String, dynamic> shipping,
    bool cod = true,
  }) async {
    final body = {
      'payment_method': cod ? 'cod' : 'razorpay',
      'payment_method_title': cod ? 'Cash on delivery' : 'Razorpay',
      'set_paid': false,
      'billing': billing,
      'shipping': shipping,
      'line_items': lineItems,
      'status': 'processing'
    };
    return _post('/orders', body);
  }
}
