import 'package:bloc/bloc.dart';
import 'package:satvik_task/data/export_data.dart';
import 'package:satvik_task/localDB/user_profile_db.dart';

import '../../../model/export_models.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<GetUserProfile>((event, emit) async {
      emit(GetUserProfileLoading());
      List<UserModel> users = await ApiServices.fetchUserProfiles(id: event.id);
      /// insert into local databse
      if(users.isEmpty)
      {
        emit(GetUserProfileFailed());
      }else{
        for(UserModel user in users)
        {
          await UserProfileDatabaseHelper().insertUser(user);
        }
        emit(GetUserProfileSuccess(users: users));
      }
    });
  }
}
