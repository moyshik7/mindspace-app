import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

final socketServiceProvider = Provider((ref) => SocketService());

class SocketService {
  io.Socket? socket;

  final _postNewController = StreamController<Map<String, dynamic>>.broadcast();
  final _postDeletedController = StreamController<Map<String, dynamic>>.broadcast();
  final _postLikedController = StreamController<Map<String, dynamic>>.broadcast();

  final _commentNewController = StreamController<Map<String, dynamic>>.broadcast();
  final _commentDeletedController = StreamController<Map<String, dynamic>>.broadcast();
  final _commentLikedController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get onPostNew => _postNewController.stream;
  Stream<Map<String, dynamic>> get onPostDeleted => _postDeletedController.stream;
  Stream<Map<String, dynamic>> get onPostLiked => _postLikedController.stream;

  Stream<Map<String, dynamic>> get onCommentNew => _commentNewController.stream;
  Stream<Map<String, dynamic>> get onCommentDeleted => _commentDeletedController.stream;
  Stream<Map<String, dynamic>> get onCommentLiked => _commentLikedController.stream;

  Future<void> connect() async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();

    socket = io.io(
      'https://api.mindspacebd.com',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .build(),
    );

    socket?.connect();

    socket?.onConnect((_) {});

    socket?.onDisconnect((_) {});

    socket?.on('post:new', (data) {
      if (data is Map) _postNewController.add(Map<String, dynamic>.from(data));
    });
    socket?.on('post:deleted', (data) {
      if (data is Map) _postDeletedController.add(Map<String, dynamic>.from(data));
    });
    socket?.on('post:liked', (data) {
      if (data is Map) _postLikedController.add(Map<String, dynamic>.from(data));
    });

    socket?.on('comment:new', (data) {
      if (data is Map) _commentNewController.add(Map<String, dynamic>.from(data));
    });
    socket?.on('comment:deleted', (data) {
      if (data is Map) _commentDeletedController.add(Map<String, dynamic>.from(data));
    });
    socket?.on('comment:liked', (data) {
      if (data is Map) _commentLikedController.add(Map<String, dynamic>.from(data));
    });
  }

  void joinPost(String postId) {
    socket?.emit('join:post', {'postId': postId});
  }

  void leavePost(String postId) {
    socket?.emit('leave:post', {'postId': postId});
  }

  void disconnect() {
    socket?.disconnect();
  }
}
