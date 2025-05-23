// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get contributor => 'DeepL(robot)';

  @override
  String get description => 'VRChat assistant app';

  @override
  String get descriptionDetailed =>
      'VRChat assistant app with intuitive UI built in Flutter';

  @override
  String get ok => 'OK';

  @override
  String get no => 'НЕТ';

  @override
  String get cancel => 'ОТМЕНА.';

  @override
  String get send => 'ПОДПИСАТЬСЯ';

  @override
  String get save => 'Сохранить';

  @override
  String get saved => 'Сохранено';

  @override
  String get success => 'Преуспел';

  @override
  String get failed => 'Не удалось';

  @override
  String get delete => 'Удалить';

  @override
  String get type => 'Тип';

  @override
  String get vrchatPublic => 'Public';

  @override
  String get vrchatFriendsPlus => 'Friends+';

  @override
  String get vrchatFriends => 'Friends';

  @override
  String get vrchatInvitePlus => 'Invite+';

  @override
  String get vrchatInvite => 'Invite';

  @override
  String get vrchatGroup => 'Group';

  @override
  String get error => 'Произошла ошибка';

  @override
  String get parseError => 'Ошибка парсинга';

  @override
  String get socketException => 'Не удалось подключиться к Интернету';

  @override
  String get unknownError => 'Неизвестная ошибка';

  @override
  String get reportMessage1 => 'Пожалуйста, сообщите разработчику';

  @override
  String get reportMessage2 =>
      'Нажмите пункт Отчет, чтобы скопировать журнал в буфер обмена и перейти на страницу отчета';

  @override
  String get tooManyRequests =>
      'Слишком много запросов Пожалуйста, подождите немного и попробуйте снова';

  @override
  String get invalidLoginInfo =>
      'Неверное имя пользователя/адрес электронной почты или пароль';

  @override
  String dateFormat1(Object inDays, Object inHours) {
    return '$inDays дней $inHours часов назад';
  }

  @override
  String dateFormat2(Object inHours, Object inMinutes) {
    return '$inHours часов $inMinutes минут назад';
  }

  @override
  String dateFormat3(Object inMinutes) {
    return '$inMinutes минут назад';
  }

  @override
  String dateFormat4(Object inSeconds) {
    return '$inSeconds секунд назад';
  }

  @override
  String get share => 'Поделиться';

  @override
  String get copy => 'Копировать';

  @override
  String get copied => 'Копируется в буфер обмена';

  @override
  String get openInBrowser => 'Открыть в браузере';

  @override
  String get openInExternalBrowser => 'Открыть во внешнем браузере';

  @override
  String get close => 'Закрыть';

  @override
  String get setting => 'Настройки';

  @override
  String get login => 'Вход в систему';

  @override
  String get username => 'Имя пользователя';

  @override
  String get usernameOrEmail => 'Имя пользователя / адрес электронной почты';

  @override
  String get password => 'Пароль';

  @override
  String get rememberPassword => 'Сохранить пароль';

  @override
  String get twoFactorAuthentication => 'Двухэтапная проверка';

  @override
  String get authenticationCode => 'Код аутентификации';

  @override
  String get unknown => 'Без имени';

  @override
  String get loginBrowser => 'Вход в систему с помощью браузера';

  @override
  String get incorrectLogin => 'Ваши данные для входа в систему неверны';

  @override
  String get home => 'Главная';

  @override
  String get onlineFriends => 'Онлайн-друзья';

  @override
  String get offlineFriends => 'Друзья вне сети';

  @override
  String get showOnlyAvailable => 'Доступно только для показа';

  @override
  String get worldDetails => 'Детали мира';

  @override
  String get worldUnfavoriteButton => 'Нелюбимая кнопка';

  @override
  String get sort => 'Сортировать по';

  @override
  String get descending => 'Порядок убывания';

  @override
  String get sortedByDefault => 'Сортировать по умолчанию';

  @override
  String get sortedByName => 'Сортировать по имени';

  @override
  String get sortedByLastLogin => 'В порядке последнего входа в систему';

  @override
  String get sortedByFriendsInInstance =>
      'Сортировать по количеству друзей в экземпляре';

  @override
  String get sortedByUpdatedDate => 'Сортировать по дате обновления';

  @override
  String get sortedByLabsPublicationDate =>
      'Сортировать по дате публикации Лаборатории';

  @override
  String get sortedByHeat => 'Сортировать по теплу';

  @override
  String get sortedByCapacity => 'Сортировать по мощности';

  @override
  String get sortedByOccupants => 'Сортировать по жильцам';

  @override
  String get display => 'Дисплей';

  @override
  String get normal => 'По умолчанию';

  @override
  String get simple => 'Простой';

  @override
  String get textOnly => 'Только текст';

  @override
  String get search => 'Поиск';

  @override
  String get friendRequest => 'Запрос друга';

  @override
  String get friendManagement => 'Управление друзьями';

  @override
  String get favoriteWorlds => 'Любимые миры';

  @override
  String get user => 'Пользователь';

  @override
  String lastLogin(Object data) {
    return 'Последний вход: $data';
  }

  @override
  String dateJoined(Object data) {
    return 'Зарегистрирован на: $data';
  }

  @override
  String get openInJsonViewer => 'Отображение в программе просмотра JSON';

  @override
  String get joinInstance => 'Пригласите себя';

  @override
  String get addFavoriteWorlds => 'Добавить любимые миры';

  @override
  String get removeFavoriteWorlds => 'Удалить из избранных миров';

  @override
  String get editBio => 'Редактировать биографию';

  @override
  String get editNote => 'Примечание редакции';

  @override
  String get sendInvite => 'Приглашение отправлено.';

  @override
  String get selfInviteDetails => 'Проверьте поле приглашения VRChat';

  @override
  String get unfriend => 'Не дружить';

  @override
  String get unfriendConfirm => 'Ты хочешь меня исключить из друзей?';

  @override
  String get requestCancel => 'Запрос на отказ от дружбы';

  @override
  String get allowFriends => 'Принять друга';

  @override
  String get denyFriends => 'Отвергнуть друга';

  @override
  String get jsonViewer => 'просмотрщик JSON';

  @override
  String get world => 'Мир';

  @override
  String get privateWorld => 'Частный мир';

  @override
  String get loadingWorld => 'Загружающийся мир';

  @override
  String get onTheWebsite => 'Онлайн на сайте';

  @override
  String occupants(Object data) {
    return 'Количество игроков: $data';
  }

  @override
  String privateOccupants(Object data) {
    return 'Количество частных игроков: $data';
  }

  @override
  String favorites(Object data) {
    return 'Избранное: $data';
  }

  @override
  String createdAt(Object data) {
    return 'Создано: $data';
  }

  @override
  String updatedAt(Object data) {
    return 'Последнее обновление: $data';
  }

  @override
  String get launchWorld => 'Создание экземпляра';

  @override
  String get openInVrchat => 'Открыть в VRChat';

  @override
  String get accountSwitch => 'Переключение счетов';

  @override
  String get accountSwitchSetting => 'Настройки переключения счетов';

  @override
  String get accountSwitchSettingDetails => 'Управление другими счетами';

  @override
  String get addAccount => 'Добавление счетов';

  @override
  String get accessibility => 'Доступность';

  @override
  String get language => 'Язык';

  @override
  String translatorDetails(Object name) {
    return 'Переведено $name';
  }

  @override
  String get deviceLightTheme => 'Если устройство имеет светлую тематику';

  @override
  String get deviceDarkTheme => 'Если на устройстве установлена темная тема';

  @override
  String get lightTheme => 'Светлая тема';

  @override
  String get darkTheme => 'Темная тема';

  @override
  String get blackTheme => 'Черная тема';

  @override
  String get trueBlackTheme => 'Настоящая черная тема';

  @override
  String get highContrastLightTheme => 'Высококонтрастная светлая тема';

  @override
  String get highContrastDarkTheme => 'Высококонтрастная темная тема';

  @override
  String get forceExternalBrowser =>
      'Принудительное использование внешнего браузера';

  @override
  String get forceExternalBrowserDetails =>
      'Принудительное открытие внешнего браузера при открытии браузера';

  @override
  String get debugMode => 'Режим отладки';

  @override
  String get account => 'Счет';

  @override
  String get logout => 'Выйти из системы';

  @override
  String get logoutDetails =>
      'Выход из системы и удаление информации о сеансе с терминала';

  @override
  String get logoutConfirm => 'Вы хотите выйти из системы?';

  @override
  String get deleteLoginInfo => 'Удалить информацию для входа в систему';

  @override
  String get deleteLoginInfoDetails =>
      'Удалить сохраненную информацию для входа в систему';

  @override
  String get deleteLoginInfoConfirm => 'Вы хотите удалить?';

  @override
  String get token => 'Токен';

  @override
  String get tokenDetails => 'Просмотр или изменение своих учетных данных';

  @override
  String get cookie => 'Печенье';

  @override
  String get permissions => 'Разрешения';

  @override
  String get domainVerification => 'Ассоциируйте приложение с доменом';

  @override
  String get domainVerificationDetails =>
      'Ассоциируйте свое приложение с vrchat.com';

  @override
  String get notSupported => 'Не поддерживается';

  @override
  String get notSupportedDetails =>
      'Это разрешение не поддерживается на данном устройстве';

  @override
  String get help => 'Помощь';

  @override
  String get contribution => 'Вклад';

  @override
  String get contributionDetails => 'Участвуйте в разработке на Github';

  @override
  String get reportDetails =>
      'Сообщать об ошибках и запрашивать у разработчиков новые возможности';

  @override
  String get developerInfo => 'Информация о разработчике';

  @override
  String get developerInfoDetails => 'Просмотр информации о разработчике';

  @override
  String get rateTheApp => 'Рейтинги';

  @override
  String get rateTheAppDetails => 'Пожалуйста, оцените нас в Google PlayStore';

  @override
  String get version => 'Версия';

  @override
  String versionDetails(Object version) {
    return 'Текущая версия: $version';
  }

  @override
  String get license => 'Лицензия';

  @override
  String get licenseDetails => 'Проверьте информацию о лицензии';

  @override
  String get report => 'Отчет';

  @override
  String get log => 'Журнал';

  @override
  String get viewDetailedLogs => 'Просмотр подробных журналов';

  @override
  String get userPolicy => 'Пользовательская политика';

  @override
  String get agree => 'Согласитесь';

  @override
  String get disagree => 'Не согласен';

  @override
  String get lookAtYourBrowser => 'Пожалуйста, проверьте ваш браузер';
}
