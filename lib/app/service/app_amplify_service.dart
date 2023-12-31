import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:panda_technician/amplifyconfiguration.dart';

class PandaAmplify {
  static Future<void> configureAmplify() async {
    // if (Amplify.isConfigured) return;
    // final api = AmplifyAPI(modelProvider: ModelProvider.instance);
    await Amplify.addPlugin(AmplifyAPI());
    await Amplify.addPlugin(AmplifyAuthCognito());

    try {
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      safePrint('An error occurred configuring Amplify: $e');
    }
  }
}
