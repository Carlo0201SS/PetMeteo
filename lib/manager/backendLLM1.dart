import 'package:dio/dio.dart';
import 'package:petmeteo/models/llm_response/LLMResponse1.dart';
import 'package:petmeteo/models/llm_request/LLMRequest1.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



class BackendLLM1 {
  final Dio dio = Dio(BaseOptions(
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
    
    headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${dotenv.env['API_KEY']}', 
      },
  ))
  ;

  Future<LLMResponse1> postLLMData(LLMRequest1 request) async {
  try {
    final Response<Map<String, dynamic>> response = await dio.post(
        'https://ai-foundry-labs.cognitiveservices.azure.com/openai/deployments/gpt-35-turbo/chat/completions?api-version=2025-01-01-preview',
         data: request.toJson(),
      );
        
    //print('Stato HTTP: ${response.statusCode}');
    //print(response);
    //print("---");
    //print(LLMResponse.fromJson(response.data!));
    return LLMResponse1.fromJson(response.data!);
  } catch (e) {
    //print("errore:");
    //print(e);
    throw Exception('Failed to load : $e');
  }
}
  
}