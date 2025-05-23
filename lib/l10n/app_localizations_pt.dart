// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

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
  String get no => 'NÃO';

  @override
  String get cancel => 'CANCELAM.';

  @override
  String get send => 'SUBMIT';

  @override
  String get save => 'Salvar';

  @override
  String get saved => 'Salvo';

  @override
  String get success => 'Foi bem sucedido';

  @override
  String get failed => 'Falha';

  @override
  String get delete => 'Excluir';

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
  String get error => 'Ocorreu um erro';

  @override
  String get parseError => 'Erro de análise';

  @override
  String get socketException => 'Não conseguia se conectar à Internet';

  @override
  String get unknownError => 'Erro desconhecido';

  @override
  String get reportMessage1 => 'Por favor, informe o desenvolvedor';

  @override
  String get reportMessage2 =>
      'Toque em Relatório para copiar o log para a área de transferência e acessar a página de relatório.';

  @override
  String get tooManyRequests =>
      'Demasiados pedidos Por favor aguarde um momento e tente novamente';

  @override
  String get invalidLoginInfo =>
      'Nome de usuário/endereço de e-mail inválido ou senha';

  @override
  String dateFormat1(Object inDays, Object inHours) {
    return '$inDays dias $inHours horas atrás';
  }

  @override
  String dateFormat2(Object inHours, Object inMinutes) {
    return '$inHours horas $inMinutes minutos atrás';
  }

  @override
  String dateFormat3(Object inMinutes) {
    return '$inMinutes minutos atrás';
  }

  @override
  String dateFormat4(Object inSeconds) {
    return '$inSeconds segundos atrás';
  }

  @override
  String get share => 'Compartilhe';

  @override
  String get copy => 'Cópia';

  @override
  String get copied => 'Copiado para prancheta';

  @override
  String get openInBrowser => 'Aberto no navegador';

  @override
  String get openInExternalBrowser => 'Aberto em navegador externo';

  @override
  String get close => 'Fechar';

  @override
  String get setting => 'Configurações';

  @override
  String get login => 'Login';

  @override
  String get username => 'Nome do usuário';

  @override
  String get usernameOrEmail => 'Nome de usuário / endereço de e-mail';

  @override
  String get password => 'Senha';

  @override
  String get rememberPassword => 'Salvar senha';

  @override
  String get twoFactorAuthentication => 'Verificação em 2 etapas';

  @override
  String get authenticationCode => 'Código de autenticação';

  @override
  String get unknown => 'Sem nome';

  @override
  String get loginBrowser => 'Entrar usando um navegador';

  @override
  String get incorrectLogin => 'Seus dados de login estão incorretos';

  @override
  String get home => 'Início';

  @override
  String get onlineFriends => 'Amigos on-line';

  @override
  String get offlineFriends => 'Amigos fora de linha';

  @override
  String get showOnlyAvailable => 'Mostrar apenas disponível';

  @override
  String get worldDetails => 'Detalhes do mundo';

  @override
  String get worldUnfavoriteButton => 'Botão desfavorável';

  @override
  String get sort => 'Ordenar por';

  @override
  String get descending => 'Ordem decrescente';

  @override
  String get sortedByDefault => 'Ordem por defeito';

  @override
  String get sortedByName => 'Ordenar pelo nome';

  @override
  String get sortedByLastLogin => 'Ordenar por capacidade último login';

  @override
  String get sortedByFriendsInInstance =>
      'Ordenar por número de amigos, por exemplo';

  @override
  String get sortedByUpdatedDate => 'Ordenar por Data de Actualização';

  @override
  String get sortedByLabsPublicationDate =>
      'Ordenar por Laboratórios data de publicação';

  @override
  String get sortedByHeat => 'Ordenar por calor';

  @override
  String get sortedByCapacity => 'Ordenar por capacidade';

  @override
  String get sortedByOccupants => 'Ordenar por ocupantes';

  @override
  String get display => 'Mostrar';

  @override
  String get normal => 'Predefinição';

  @override
  String get simple => 'Simples';

  @override
  String get textOnly => 'Somente texto';

  @override
  String get search => 'Pesquisa';

  @override
  String get friendRequest => 'Pedido de amigo';

  @override
  String get friendManagement => 'Gestão de amigos';

  @override
  String get favoriteWorlds => 'Mundos preferidos';

  @override
  String get user => 'Usuário';

  @override
  String lastLogin(Object data) {
    return 'Último login: $data';
  }

  @override
  String dateJoined(Object data) {
    return 'Registrado em: $data';
  }

  @override
  String get openInJsonViewer => 'Visualização em JSON viewer';

  @override
  String get joinInstance => 'Convide-se';

  @override
  String get addFavoriteWorlds => 'Adicionar mundos favoritos';

  @override
  String get removeFavoriteWorlds => 'Remover de Mundos Favoritos';

  @override
  String get editBio => 'Editar Bio';

  @override
  String get editNote => 'Nota de edição';

  @override
  String get sendInvite => 'Convite enviado.';

  @override
  String get selfInviteDetails => 'Verifique seu campo de convite VRChat';

  @override
  String get unfriend => 'Inamigo';

  @override
  String get unfriendConfirm => 'Você quer me desamparar?';

  @override
  String get requestCancel => 'Solicitação de não amizade';

  @override
  String get allowFriends => 'Aceitar amigo';

  @override
  String get denyFriends => 'Rejeitar amigo';

  @override
  String get jsonViewer => 'Telespectador do JSON';

  @override
  String get world => 'Mundo';

  @override
  String get privateWorld => 'Mundo privado';

  @override
  String get loadingWorld => 'Mundo da Carga';

  @override
  String get onTheWebsite => 'Online no site';

  @override
  String occupants(Object data) {
    return 'Número de jogadores: $data';
  }

  @override
  String privateOccupants(Object data) {
    return 'Número de jogadores privados: $data';
  }

  @override
  String favorites(Object data) {
    return 'Favoritos: $data';
  }

  @override
  String createdAt(Object data) {
    return 'Criado: $data';
  }

  @override
  String updatedAt(Object data) {
    return 'Última atualização: $data';
  }

  @override
  String get launchWorld => 'Criação da instância';

  @override
  String get openInVrchat => 'Aberto em VRChat';

  @override
  String get accountSwitch => 'Mudança de conta';

  @override
  String get accountSwitchSetting => 'Configurações de mudança de conta';

  @override
  String get accountSwitchSettingDetails => 'Gerenciar outras contas';

  @override
  String get addAccount => 'Acréscimo de contas';

  @override
  String get accessibility => 'Acessibilidade';

  @override
  String get language => 'Idioma';

  @override
  String translatorDetails(Object name) {
    return 'Tradução por $name';
  }

  @override
  String get deviceLightTheme => 'Se o dispositivo for de tema leve';

  @override
  String get deviceDarkTheme => 'Se o dispositivo for um tema sombrio';

  @override
  String get lightTheme => 'Tema leve';

  @override
  String get darkTheme => 'Tema sombrio';

  @override
  String get blackTheme => 'Tema negro';

  @override
  String get trueBlackTheme => 'Tema negro verdadero';

  @override
  String get highContrastLightTheme => 'Tema de luz de alto contraste';

  @override
  String get highContrastDarkTheme => 'Tema escuro de alto contraste';

  @override
  String get forceExternalBrowser => 'Forçar navegador externo';

  @override
  String get forceExternalBrowserDetails =>
      'Força um navegador externo a abrir ao abrir o navegador';

  @override
  String get debugMode => 'Modo de depuração';

  @override
  String get account => 'Conta';

  @override
  String get logout => 'Sair';

  @override
  String get logoutDetails =>
      'Sai e remove as informações da sessão do terminal';

  @override
  String get logoutConfirm => 'Você quer terminar a sessão?';

  @override
  String get deleteLoginInfo => 'Eliminar informações de login';

  @override
  String get deleteLoginInfoDetails =>
      'Excluir informações de login armazenadas';

  @override
  String get deleteLoginInfoConfirm => 'Você quer apagar?';

  @override
  String get token => 'Token';

  @override
  String get tokenDetails => 'Veja ou altere suas credenciais';

  @override
  String get cookie => 'Cookie';

  @override
  String get permissions => 'Permissões';

  @override
  String get domainVerification => 'Associar aplicativo com domínio';

  @override
  String get domainVerificationDetails =>
      'Associe seu aplicativo ao vrchat.com';

  @override
  String get notSupported => 'Não suportado';

  @override
  String get notSupportedDetails =>
      'Esta permissão não é suportada por este dispositivo';

  @override
  String get help => 'Ajuda';

  @override
  String get contribution => 'Contribua';

  @override
  String get contributionDetails =>
      'Contribuir para o desenvolvimento no Github';

  @override
  String get reportDetails =>
      'Relatar bugs e solicitar novas funcionalidades aos desenvolvedores';

  @override
  String get developerInfo => 'Informações para desenvolvedores';

  @override
  String get developerInfoDetails => 'Ver informações sobre o desenvolvedor';

  @override
  String get rateTheApp => 'Classificações';

  @override
  String get rateTheAppDetails =>
      'Por favor, classifique-nos na Google PlayStore';

  @override
  String get version => 'Versão';

  @override
  String versionDetails(Object version) {
    return 'Versão atual: $version';
  }

  @override
  String get license => 'Licença';

  @override
  String get licenseDetails => 'Verificar informações sobre a licença';

  @override
  String get report => 'Relatório';

  @override
  String get log => 'Registo';

  @override
  String get viewDetailedLogs => 'Ver registos detalhados';

  @override
  String get userPolicy => 'Política do Utilizador';

  @override
  String get agree => 'Concorda';

  @override
  String get disagree => 'Discordar';

  @override
  String get lookAtYourBrowser => 'Por favor verifique o seu navegador';
}
