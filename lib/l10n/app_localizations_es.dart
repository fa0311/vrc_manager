// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

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
  String get no => 'NO';

  @override
  String get cancel => 'CANCELAR.';

  @override
  String get send => 'ENVIAR';

  @override
  String get save => 'Guardar';

  @override
  String get saved => 'Guardado';

  @override
  String get success => 'Sucedido';

  @override
  String get failed => 'Fallido';

  @override
  String get delete => 'Borrar';

  @override
  String get type => 'Tipo';

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
  String get error => 'Se ha producido un error';

  @override
  String get parseError => 'Error de análisis';

  @override
  String get socketException => 'No se puede conectar a Internet';

  @override
  String get unknownError => 'Error desconocido';

  @override
  String get reportMessage1 => 'Por favor, informe al desarrollador';

  @override
  String get reportMessage2 =>
      'Pulse Informe para copiar el registro en el portapapeles y acceder a la página del informe';

  @override
  String get tooManyRequests =>
      'Demasiadas solicitudes Por favor, espere un momento e inténtelo de nuevo';

  @override
  String get invalidLoginInfo =>
      'Nombre de usuario/dirección de correo electrónico o contraseña no válidos';

  @override
  String dateFormat1(Object inDays, Object inHours) {
    return '$inDays días $inHours horas atrás';
  }

  @override
  String dateFormat2(Object inHours, Object inMinutes) {
    return '$inHours horas $inMinutes minutos atrás';
  }

  @override
  String dateFormat3(Object inMinutes) {
    return '$inMinutes hace minutos';
  }

  @override
  String dateFormat4(Object inSeconds) {
    return '$inSeconds hace segundos';
  }

  @override
  String get share => 'Compartir';

  @override
  String get copy => 'Copiar';

  @override
  String get copied => 'Copiado en el portapapeles';

  @override
  String get openInBrowser => 'Abrir en el navegador';

  @override
  String get openInExternalBrowser => 'Abrir en un navegador externo';

  @override
  String get close => 'Cerrar';

  @override
  String get setting => 'Ajustes';

  @override
  String get login => 'Inicio de sesión';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get usernameOrEmail =>
      'Nombre de usuario / Dirección de correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get rememberPassword => 'Guardar contraseña';

  @override
  String get twoFactorAuthentication => 'Verificación en dos pasos';

  @override
  String get authenticationCode => 'Código de autentificación';

  @override
  String get unknown => 'Sin nombre';

  @override
  String get loginBrowser => 'Iniciar sesión con un navegador';

  @override
  String get incorrectLogin => 'Sus datos de acceso son incorrectos';

  @override
  String get home => 'Inicio';

  @override
  String get onlineFriends => 'Amigos en línea';

  @override
  String get offlineFriends => 'Amigos fuera de línea';

  @override
  String get showOnlyAvailable => 'Mostrar sólo disponible';

  @override
  String get worldDetails => 'Detalles del mundo';

  @override
  String get worldUnfavoriteButton => 'Botón Desfavorito';

  @override
  String get sort => 'Ordenar por';

  @override
  String get descending => 'Orden descendente';

  @override
  String get sortedByDefault => 'Orden por defecto';

  @override
  String get sortedByName => 'Ordenar por nombre';

  @override
  String get sortedByLastLogin => 'Por orden de último ingreso';

  @override
  String get sortedByFriendsInInstance =>
      'Ordenar por número de amigos en la instancia';

  @override
  String get sortedByUpdatedDate => 'Ordenar por fecha de actualización';

  @override
  String get sortedByLabsPublicationDate =>
      'Ordenar por fecha de publicación de Labs';

  @override
  String get sortedByHeat => 'Ordenar por calor';

  @override
  String get sortedByCapacity => 'Ordenar por capacidad';

  @override
  String get sortedByOccupants => 'Ordenar por ocupantes';

  @override
  String get display => 'Mostrar';

  @override
  String get normal => 'Por defecto';

  @override
  String get simple => 'Simple';

  @override
  String get textOnly => 'Sólo texto';

  @override
  String get search => 'Buscar en';

  @override
  String get friendRequest => 'Solicitud de amistad';

  @override
  String get friendManagement => 'Gestión de amigos';

  @override
  String get favoriteWorlds => 'Mundos favoritos';

  @override
  String get user => 'Usuario';

  @override
  String lastLogin(Object data) {
    return 'Último acceso: $data';
  }

  @override
  String dateJoined(Object data) {
    return 'Registrado el: $data';
  }

  @override
  String get openInJsonViewer => 'Visualización en el visor JSON';

  @override
  String get joinInstance => 'Invítese a sí mismo';

  @override
  String get addFavoriteWorlds => 'Añadir mundos favoritos';

  @override
  String get removeFavoriteWorlds => 'Eliminado de mundos favoritos';

  @override
  String get editBio => 'Editar Biografía';

  @override
  String get editNote => 'Editar nota';

  @override
  String get sendInvite => 'Invitación enviada.';

  @override
  String get selfInviteDetails => 'Comprueba tu campo de invitación de VRChat';

  @override
  String get unfriend => 'Quita la amistad a';

  @override
  String get unfriendConfirm => '¿Quieres dejar de ser mi amigo?';

  @override
  String get requestCancel => 'Petición de baja de la lista de amigos';

  @override
  String get allowFriends => 'Aceptar amigo';

  @override
  String get denyFriends => 'Rechazar amigo';

  @override
  String get jsonViewer => 'Visor JSON';

  @override
  String get world => 'Mundo';

  @override
  String get privateWorld => 'Mundo privado';

  @override
  String get loadingWorld => 'Mundo Cargando';

  @override
  String get onTheWebsite => 'En línea en el sitio web';

  @override
  String occupants(Object data) {
    return 'Número de jugadores: $data';
  }

  @override
  String privateOccupants(Object data) {
    return 'Número de jugadores privados: $data';
  }

  @override
  String favorites(Object data) {
    return 'Favoritos: $data';
  }

  @override
  String createdAt(Object data) {
    return 'Creado: $data';
  }

  @override
  String updatedAt(Object data) {
    return 'Última actualización: $data';
  }

  @override
  String get launchWorld => 'Creación de instancias';

  @override
  String get openInVrchat => 'Abrir en VRChat';

  @override
  String get accountSwitch => 'Cambio de cuenta';

  @override
  String get accountSwitchSetting => 'Configuración del cambio de cuenta';

  @override
  String get accountSwitchSettingDetails => 'Gestionar otras cuentas';

  @override
  String get addAccount => 'Añadir cuentas';

  @override
  String get accessibility => 'Accesibilidad';

  @override
  String get language => 'Idioma';

  @override
  String translatorDetails(Object name) {
    return 'Traducido por $name';
  }

  @override
  String get deviceLightTheme => 'Si el dispositivo es de tema ligero';

  @override
  String get deviceDarkTheme => 'Si el dispositivo es de tema oscuro';

  @override
  String get lightTheme => 'Tema luminoso';

  @override
  String get darkTheme => 'Tema oscuro';

  @override
  String get blackTheme => 'Tema negro';

  @override
  String get trueBlackTheme => 'Tema negro verdadero';

  @override
  String get highContrastLightTheme => 'Tema luminoso de alto contraste';

  @override
  String get highContrastDarkTheme => 'Tema oscuro de alto contraste';

  @override
  String get forceExternalBrowser => 'Forzar el navegador externo';

  @override
  String get forceExternalBrowserDetails =>
      'Obliga a abrir un navegador externo al abrir el navegador';

  @override
  String get debugMode => 'Modo depuración';

  @override
  String get account => 'Cuenta';

  @override
  String get logout => 'Cerrar la sesión';

  @override
  String get logoutDetails =>
      'Cierra la sesión y elimina la información de la sesión del terminal';

  @override
  String get logoutConfirm => '¿Quieres cerrar la sesión?';

  @override
  String get deleteLoginInfo => 'Borrar los datos de acceso';

  @override
  String get deleteLoginInfoDetails =>
      'Borrar la información de inicio de sesión almacenada';

  @override
  String get deleteLoginInfoConfirm => '¿Quieres borrarte?';

  @override
  String get token => 'Ficha';

  @override
  String get tokenDetails => 'Ver o cambiar sus credenciales';

  @override
  String get cookie => 'Cookie';

  @override
  String get permissions => 'Permisos';

  @override
  String get domainVerification => 'Asociar la aplicación con el dominio';

  @override
  String get domainVerificationDetails => 'Asocie su aplicación con vrchat.com';

  @override
  String get notSupported => 'No se admite';

  @override
  String get notSupportedDetails =>
      'Este permiso no es compatible con este dispositivo';

  @override
  String get help => 'Ayuda';

  @override
  String get contribution => 'Contribuir';

  @override
  String get contributionDetails => 'Contribuir al desarrollo en Github';

  @override
  String get reportDetails =>
      'Informar de los errores y solicitar nuevas funciones a los desarrolladores';

  @override
  String get developerInfo => 'Información para el desarrollador';

  @override
  String get developerInfoDetails => 'Ver información sobre el promotor';

  @override
  String get rateTheApp => 'Clasificaciones';

  @override
  String get rateTheAppDetails => 'Califíquenos en Google PlayStore';

  @override
  String get version => 'Versión';

  @override
  String versionDetails(Object version) {
    return 'Versión actual: $version';
  }

  @override
  String get license => 'Licencia';

  @override
  String get licenseDetails => 'Comprobar la información de la licencia';

  @override
  String get report => 'Informe';

  @override
  String get log => 'Registro';

  @override
  String get viewDetailedLogs => 'Ver registros detallados';

  @override
  String get userPolicy => 'Política de usuarios';

  @override
  String get agree => 'De acuerdo';

  @override
  String get disagree => 'En desacuerdo';

  @override
  String get lookAtYourBrowser => 'Compruebe su navegador';
}
