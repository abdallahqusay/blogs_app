import 'package:blogs_app/core/error/expecions.dart';
import 'package:blogs_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> signinWithEmailPassword({
    required String email,
    required String password,
  });
  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);
  @override
  
  Session? get currentUserSession => supabaseClient.auth.currentSession;
  @override
  Future<UserModel> signinWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      print(response);
      if (response.user == null) {
        throw ServerExeption("user is not signup");
      }
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerExeption(e.toString());
    }
  }

  @override
  Future<UserModel> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {"name": name},
      );

      if (response.user == null) {
        throw ServerExeption("User is null");
      }
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerExeption(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if(currentUserSession!=null){
     final userData= await supabaseClient
          .from('profiles')
          .select()
          .eq('id', currentUserSession!.user.id);
          return UserModel.fromJson(userData.first);
          
          }

          return null;
    } catch (e) {
      throw ServerExeption(e.toString());
    }
  }
}
