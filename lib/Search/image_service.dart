import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ImageService {
  static Future<String?> getSingleImageUrl(String apiKey, String query) async {
    final String url =
        "https://serpapi.com/search.json?engine=google_images&q=fresh+$query&hl=en&gl=us&tbs=ift:webp&api_key=$apiKey";

    int retryCount = 0;
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        final response =
            await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data.containsKey('images_results') &&
              data['images_results'] is List &&
              data['images_results'].isNotEmpty) {
            final List images = data['images_results'];
            final Map<String, dynamic> firstImage = images[0];

            if (firstImage.containsKey('original')) {
              return firstImage['original'];
            } else {
              print("First image does not contain 'original' key.");
              return null;
            }
          } else {
            print("images_results not found or empty.");
            return null;
          }
        } else {
          print("Error: ${response.statusCode}");
          print(response.body);
          return null;
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

    return "https://www.pngmart.com/files/16/Google-Logo-PNG-Image.png"; // Return default after max retries
  }
}
