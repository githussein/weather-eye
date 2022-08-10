import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Auth.dart';

/// user engagement (like, comment, send photo)
class Engagement with ChangeNotifier {
  Future<void> likePost(BuildContext ctx, int outlookId) async {
    try {
      await http.post(
        Uri.parse('https://appapp-backend.com/api/submit-like'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': Provider.of<Auth>(ctx, listen: false).userToken,
        },
        body: json.encode({'outlook_id': outlookId}),
      );

      notifyListeners();
    } catch (error) {
      print('problem like the post');
      rethrow;
    }
  }

  Future<void> comment(BuildContext ctx, int outlookId, String comment) async {
    try {
      await http.post(
        Uri.parse('https://appapp-backend.com/api/send-comment'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': Provider.of<Auth>(ctx, listen: false).userToken,
        },
        body: json.encode({'outlook_id': outlookId, 'comment': comment}),
      );

      notifyListeners();
    } catch (error) {
      print('problem like the post');
      rethrow;
    }
  }

  Future<void> sendTicket(String email, String content) async {
    try {
      final response = await http.post(
        Uri.parse('https://app.app-backend.com/api/send-ticket'),
        body: json.encode({'email': email, 'content': content}),
      );

      print('statusBody: ${response.statusCode}');
      notifyListeners();
      // return response.statusCode;
    } catch (error) {
      print('problem sending a ticket.');
      rethrow;
    }
  }
}
