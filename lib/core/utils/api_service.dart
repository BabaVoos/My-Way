import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_way/models/get_route_response_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  Dio dio = Dio(
    BaseOptions(headers: {'Accept': '*/*'}, baseUrl: ApiConstants.baseUrl),
  );

  ApiService() {
    dio.options.baseUrl = ApiConstants.baseUrl;
    dio.options.connectTimeout = Duration(seconds: 60);
    dio.options.receiveTimeout = Duration(seconds: 60);
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  Future<GetRouteResponseModel> getRoute(
    LatLng from,
    LatLng to,
    String profile,
  ) async {
    try {
      final response = await dio.get(
        '$profile/${from.longitude},${from.latitude};${to.longitude},${to.latitude}',
        queryParameters: {'overview': 'full', 'geometries': 'geojson'},
      );
      return GetRouteResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}

class ApiConstants {
  static const String baseUrl = 'https://router.project-osrm.org/route/v1/';
  static const String apiOptions = 'overview=full&geometries=geojson';
}
