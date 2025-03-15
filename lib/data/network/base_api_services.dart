abstract class BaseApiServices {

  Future<dynamic> getApi(String url);
  Future <Map<String, dynamic>> postApi({required String url,required Map<String, dynamic> data});
  
}