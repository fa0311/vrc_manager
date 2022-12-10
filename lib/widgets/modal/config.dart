enum UserModalType {
  self,
  onlineFriends,
  offlineFriends,
  user;
}

class UserModalData {
  bool editBio = false;
  bool editNote = false;
  bool shareUrl = false;
  bool profileAction = false;
}

UserModalData getUserModalConfig({
  required UserModalType type,
  required String searchingText,
}) {
  switch (type) {
    case UserModalType.self:
      return UserModalData();
    case UserModalType.onlineFriends:
      return UserModalData();
    case UserModalType.offlineFriends:
      return UserModalData();
    case UserModalType.user:
      return UserModalData();
  }
}
