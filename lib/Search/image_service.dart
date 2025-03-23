import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ImageService {
  static Future<String?> getSingleImageUrl(String apiKey, String query) async {
    final String url =
        "https://www.googleapis.com/customsearch/v1?key=$apiKey&cx=e113eaf7402b44f7e&q=fresh+$query+food&searchType=image&fileType=jpg";

    int retryCount = 0;
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        final response =
            await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data.containsKey('items') &&
              data['items'] is List &&
              data['items'].isNotEmpty) {
            final List items = data['items'];
            final Map<String, dynamic> firstItem = items[0];

            if (firstItem.containsKey('link')) {
              return firstItem['link'];
            } else {
              print("First item does not contain 'link' key.");
              return null;
            }
          } else {
            print("items not found or empty.");
            return null;
          }
        } else {
          print("Error: ${response.statusCode}");
          print(response.body);
          return "https://th.bing.com/th/id/OIP.oYPGHQorMluB7LhtQUmzTgHaEK?rs=1&pid=ImgDetMain";
        }
      } on TimeoutException catch (_) {
        retryCount++;
        print('Image request timed out. Retry $retryCount...');
        if (retryCount >= maxRetries) {
          return "https://th.bing.com/th/id/OIP.oYPGHQorMluB7LhtQUmzTgHaEK?rs=1&pid=ImgDetMain";
        }
        await Future.delayed(Duration(seconds: 1)); // Delay before retry
      } catch (e) {
        retryCount++;
        print("Failed to fetch: $e. Retry $retryCount...");
        if (retryCount >= maxRetries) {
          return "https://th.bing.com/th/id/OIP.oYPGHQorMluB7LhtQUmzTgHaEK?rs=1&pid=ImgDetMain";
        }
        await Future.delayed(Duration(seconds: 1)); // Delay before retry
      }
    }

    return "https://th.bing.com/th/id/OIP.oYPGHQorMluB7LhtQUmzTgHaEK?rs=1&pid=ImgDetMain";
  }
}
