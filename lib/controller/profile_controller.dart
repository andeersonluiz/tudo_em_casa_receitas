// ignore_for_file: constant_identifier_names

import 'package:tudo_em_casa_receitas/controller/user_controller.dart';
import 'package:tudo_em_casa_receitas/firebase/firebase_handler.dart';
import 'package:tudo_em_casa_receitas/model/user_info_model.dart';
import 'package:tudo_em_casa_receitas/model/user_model.dart';
import 'package:get/get.dart';
import 'package:tudo_em_casa_receitas/route/app_pages.dart';

enum StatusMyRecipesProfile { None, Loading, Error, Finished }

class ProfileController extends FullLifeCycleController
    with FullLifeCycleMixin {
  var profileSelected = UserModel.empty().obs;
  var isPhotoWallpaperSelected = false.obs;
  var isPhotoImageSelected = false.obs;
  var photoWallpaperSelected = "";
  var photoImageSelected = "";
  var myRecipesProfile = [].obs;
  var persistData = false;
  var modifyEditData = false;
  var modifyPhotoData = false;
  var isLoadingUpdateFollowUser = false.obs;
  var isLoading = false.obs;
  var usernameText = "";
  var descriptionText = "";
  var statusMyRecipesProfile = StatusMyRecipesProfile.None.obs;

  var isFollowing = false.obs;
  var initialIsFollowing = false;
  var updatedLike = false;
  Future<void> loadData(String userId) async {
    var userLoaded = await FirebaseBaseHelper.getUserData(userId);
    profileSelected.value = userLoaded;
    photoWallpaperSelected = userLoaded.wallpaperImage;
    photoImageSelected = userLoaded.image;
  }

  updateProfilePhoto(String photoSelected, {required bool isWallpaper}) {
    if (isWallpaper) {
      profileSelected.value.wallpaperImage = photoSelected;
      isPhotoWallpaperSelected.value = true;
      isPhotoWallpaperSelected.refresh();
    } else {
      profileSelected.value.image = photoSelected;
      isPhotoImageSelected.value = true;
      isPhotoImageSelected.refresh();
      modifyPhotoData = true;
    }
  }

  confirmProfilePhoto() async {
    isLoading.value = true;
    var result = await FirebaseBaseHelper.updateUser(profileSelected.value);
    if (result == "") {
      isPhotoWallpaperSelected.value = false;
      isPhotoImageSelected.value = false;
      persistData = true;
    }

    isLoading.value = false;
    return result;
  }

  removePhotoSelected() {
    isPhotoWallpaperSelected.value = false;
    isPhotoImageSelected.value = false;
    profileSelected.value.wallpaperImage = photoWallpaperSelected;
    profileSelected.value.image = photoImageSelected;
    isPhotoImageSelected.refresh();
  }

  getRecipesFromUser(int crossAxisCount) async {
    statusMyRecipesProfile.value = StatusMyRecipesProfile.Loading;
    try {
      myRecipesProfile.assignAll(await FirebaseBaseHelper.getRecipesFromUser(
          profileSelected.value,
          crossAxisCount: crossAxisCount));
      statusMyRecipesProfile.value = StatusMyRecipesProfile.Finished;
    } catch (e) {
      statusMyRecipesProfile.value = StatusMyRecipesProfile.Error;
    }
  }

  updateUsernameText(String text) {
    usernameText = text;
  }

  updateDescriptionText(String text) {
    descriptionText = text;
  }

  changedAnyData() {
    if (profileSelected.value.name == usernameText &&
        profileSelected.value.description == descriptionText &&
        !isPhotoImageSelected.value &&
        !isPhotoWallpaperSelected.value) {
      return false;
    }
    return true;
  }

  initializeFollow(UserModel currentUser) {
    initialIsFollowing = profileSelected.value.followersList
        .map((e) => e.idUser)
        .toList()
        .contains(currentUser.id);

    isFollowing.value = initialIsFollowing;
  }

  updateFollow(UserModel currentUser) {
    isFollowing.value = !isFollowing.value;
    if (isFollowing.value) {
      profileSelected.value.followers += 1;
    } else {
      profileSelected.value.followers -= 1;
    }
  }

  updateUser() async {
    isLoading.value = true;
    if (profileSelected.value.name != usernameText || modifyPhotoData) {
      persistData = true;
      modifyEditData = true;
    } else {
      modifyEditData = false;
    }
    profileSelected.value.name = usernameText;
    profileSelected.value.description = descriptionText;
    var result = await FirebaseBaseHelper.updateUser(profileSelected.value,
        modifyUserInfo: modifyEditData);
    if (result == "") {
      isPhotoWallpaperSelected.value = false;
      isPhotoImageSelected.value = false;
      modifyPhotoData = false;
      modifyEditData = false;
      profileSelected.refresh();
    }

    isLoading.value = false;
    return result;
  }

  updateFollowUser() async {
    if (isFollowing.value == initialIsFollowing) return;
    isLoadingUpdateFollowUser.value = true;
    UserController userController = Get.find();
    var currentUser = userController.currentUser.value;
    var profileUser = profileSelected.value;
    if (isFollowing.value) {
      profileUser.followersList.add(UserInfo(
          idUser: currentUser.id,
          name: currentUser.name,
          imageUrl: currentUser.image,
          followers: currentUser.followers));
      currentUser.followingList.add(UserInfo(
          idUser: profileUser.id,
          name: profileUser.name,
          imageUrl: profileUser.image,
          followers: profileUser.followers));
    } else {
      profileUser.followersList
          .removeWhere((value) => value.idUser == currentUser.id);
      currentUser.followingList
          .removeWhere((value) => value.idUser == profileUser.id);
    }
    profileUser.followers = profileUser.followersList.length;
    currentUser.following = currentUser.followingList.length;

    var result = await FirebaseBaseHelper.updateUsers(currentUser, profileUser);
    if (result == "") {
      isPhotoWallpaperSelected.value = false;
      isPhotoImageSelected.value = false;
      modifyPhotoData = false;
      modifyEditData = false;
      updatedLike = true;
      initialIsFollowing = isFollowing.value;
      profileSelected.refresh();
    }

    isLoading.value = false;

    return result;
  }

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {
    if (Routes.PROFILE == Get.currentRoute) {
      updateFollowUser();
    }
  }

  @override
  void onResumed() {}
}
