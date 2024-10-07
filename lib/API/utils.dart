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
        print('Token has expired, please sign in to continue');

        // Optionally, you could refresh the token and retry the request
        Tuple2<int, String> newToken = await getNewToken(false);
        print("newtoken is gotten: ${newToken.item2}");
        // error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        // return dio.request(error.requestOptions.path, options: error.requestOptions);
      }
      // Handle the response here if needed
      return handler.next(response); // Continue to response
    },
    onError: (DioException error, handler) async {
      // Handle 401 (Unauthorized) errors
      if (error.response?.statusCode == 401) {
        // Notify user that the token has expired
        print('Token has expired, please sign in to continue');

        // Show an alert or redirect to login page
        // For example, using a Flutter state management solution:
        // context.read<UserProvider>().setShowAlert('Token has expired, please sign in to continue');
        // context.read<UserProvider>().setIsAuth(false);

        // Optionally, you could refresh the token and retry the request
        // final newToken = await refreshToken();
        // error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        // return dio.request(error.requestOptions.path, options: error.requestOptions);
      }

      return handler.next(error); // Continue with the error
    },
  ));
}
