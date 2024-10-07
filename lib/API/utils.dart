import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fuel_dey_buyers/API/auths_functions.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
import 'package:path/path.dart';
import 'package:tuple/tuple.dart';

String baseURL = dotenv.env['BASE_URL']!;

// Create a Dio instance with custom configurations
Dio dio = Dio(BaseOptions(
  baseUrl: baseURL,
  connectTimeout: const Duration(seconds: 10), // Set connection timeout
  receiveTimeout: const Duration(seconds: 10), // Set receive timeout
));

// Function to setup Dio interceptors
void setupDioInterceptors() {
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      String? token = await store.state.userToken["accesstoken"];

      // Set the token in the headers
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      // print("interceptor request: $token");

      options.validateStatus = (status) {
        return status != null && status < 500; // Accept all status codes < 500
      };
      return handler.next(options); // Continue the request
    },
    onResponse: (response, handler) async {
      // print(
      //     "interceptor response: ${response.statusCode}, ${response.statusMessage}");
      if (response.statusCode == 401 ||
          response.statusMessage == "Unauthorized") {
        // Notify user that the token has expired
        print(
            'Token has expired, attempting to refresh token and retry request.');

        // Optionally, you could refresh the token and retry the request
        Tuple2<int, String> newToken = await getNewToken(false);
        String newAccessToken = newToken.item2;

        // print("newtoken is gotten: $newAccessToken");

        var requestOptions = response.requestOptions;

        // Set the new token in the headers
        requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

        // Clone the request with the updated token and send it again
        final retryResponse = await dio.request(
          requestOptions.path,
          options: Options(
            method: requestOptions.method,
            headers: requestOptions.headers,
          ),
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
        );

        return handler.resolve(retryResponse); // Return the retry response
      }

      return handler.next(response); // Continue to response
    },
    onError: (DioException error, handler) async {
      print("interceptor error: ${error.response?.statusCode}");

      return handler.next(error); // Continue with the error
    },
  ));
}
