import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';

class WidgetContext {
  late AppConfig appConfig;
  late VRChatAPI vrhatLoginSession;
  WidgetContext(this.appConfig, this.vrhatLoginSession);
}
