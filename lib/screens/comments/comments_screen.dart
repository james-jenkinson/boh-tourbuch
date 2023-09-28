import 'package:boh_tourbuch/screens/comments/bloc/comments_bloc.dart';
import 'package:flutter/material.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late CommentsBloc _commentsBloc;

  @override
  void initState() {
    _commentsBloc = CommentsBloc();
    super.initState();
  }

  @override
  void dispose() {
    _commentsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: const SafeArea(
        child: Center(
          child: Column(
            children: [
            ],
          ),
        ),
      ),
    );
  }
}
