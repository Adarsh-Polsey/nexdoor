import 'dart:developer';

import 'package:dio/dio.dart';  // Import if you're using Dio
import 'package:nexdoor/features/ai_chat/models/message_model.dart';


class ChatRepository { 
  
  Future<Message> sendQuery(String query) async {
    try {
      final Response response = await Dio().get(
        'http://127.0.0.1:8000/api/v1/chatbot/chat_ai',
        queryParameters: {'query': query},
      );
      
      // Handle the Response object properly
      final Map<String, dynamic> data;
      if (response.statusCode==200) {
        // If using Dio
        data = response.data;
      } else {
        throw TypeError();
      }
      
      String processedResponse = _processResponse(data);
      log("processedResponse: $processedResponse");
      return Message(
        text: processedResponse,
        isUser: false,
        status: MessageStatus.delivered,
      );
    } catch (e,s) {
      return Message(
        text: "Sorry, feels like something went wrong. Please try again later. $e $s",
        isUser: false,
        status: MessageStatus.error,
      );
    }
  }
  String _processResponse(Map<String, dynamic> response) {
  if (response.containsKey('answer')) {
    // Handle answer response
    return response['answer'];
  } else if (response.containsKey('results') && 
      response['results'] is List && 
      (response['results'] as List).isNotEmpty) {
    // Handle structured data results
    final results = response['results'] as List;
    String text = "Found ${results.length} results:\n";
    
    for (var i = 0; i < results.length && i < 5; i++) {
      text += "${results[i]}\n";
    }
    
    if (results.length > 5) {
      text += "...and ${results.length - 5} more items";
    }
    
      String cleanText = text.replaceAll('*', '');
      return cleanText;
  } else if (response.containsKey('response')) {
    // Handle text response
    return response['response'];
  } else if (response.containsKey('sql_query')) {
    // Handle SQL query response
    String text = "SQL Query: ${response['sql_query']}\n\n";
    if (response.containsKey('results')) {
      text += "Results: ${response['results']}";
    }
    return text;
  } else {
    // Fallback
    return "Received response: $response";
  }
}
}