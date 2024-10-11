// import 'package:forms_project/services/configuration_api.dart';
// import 'package:dio/dio.dart';
// import 'package:forms_project/services/types.dart';
//
// Future<ApiResponse> makeRequest(
//     String method, String url, Object? object) async {
//   ApiResponse responseApi = ApiResponse();
//   Api api = Api();
//   try {
//     switch (method) {
//       case "GET":
//         api.response = await dio.get(url, data: object);
//         break;
//       case "POST":
//         api.response = await dio.post(url, data: object);
//         break;
//       case "PUT":
//         api.response = await dio.put(url, data: object);
//         break;
//       case "DELETE":
//         api.response = await dio.delete(url, data: object);
//         break;
//     }
//     responseApi.statusCode = api.response.statusCode!;
//     responseApi.response = api.response.data;
//     return responseApi;
//   } on DioException catch (e) {
//     responseApi.statusCode = e.response!.statusCode!;
//     responseApi.error = e.response?.data;
//     return responseApi;
//   }
// }
