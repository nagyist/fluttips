import 'dart:async';

import 'package:flutter_template/core/common/extension/string_extensions.dart';
import 'package:flutter_template/core/common/helper/enum_helpers.dart';
import 'package:flutter_template/core/common/helper/env_helper.dart';
import 'package:flutter_template/gen/assets.gen.dart';

enum Environments {
  development,
  staging,
  production,
}

extension EnviromentPath on Environments {
  String get fileName {
    switch (this) {
      case Environments.development:
        return 'development';
      case Environments.staging:
        return 'staging';
      case Environments.production:
        return 'production';
    }
  }

  String get path => 'assets/environments/' + fileName;
}

abstract class Config {
  static late String apiBaseUrl;
  static late String supabaseApiKey;

  static final _environment = enumFromString(
          Environments.values, const String.fromEnvironment('ENV')) ??
      Environments.development;

  static Future<void> initialize() async {
    await _EnvConfig._setupEnv(_environment);
    _initializeEnvVariables();
  }

  static void _initializeEnvVariables() {
    apiBaseUrl = _EnvConfig.getEnvVariable(_EnvConfig.ENV_KEY_API_BASE_URL)!;
    supabaseApiKey =
        _EnvConfig.getEnvVariable(_EnvConfig.ENV_KEY_SUPABASE_API_KEY)!;
  }
}

abstract class _EnvConfig {
  static const ENV_KEY_API_BASE_URL = 'API_BASE_URL';
  static const ENV_KEY_SUPABASE_API_KEY = 'SUPABASE_API_KEY';

  static const systemEnv = {
    ENV_KEY_API_BASE_URL: String.fromEnvironment(ENV_KEY_API_BASE_URL),
    ENV_KEY_SUPABASE_API_KEY: String.fromEnvironment(ENV_KEY_SUPABASE_API_KEY),
  };

  static final Map<String, String> _envFileEnv = {};

  static String? getEnvVariable(String key) =>
      _EnvConfig.systemEnv[key].ifNullOrBlank(() => _envFileEnv[key]);

  static Future<void> _setupEnv(Environments env) async {
    _envFileEnv
      ..addAll(await loadEnvs(Assets.environments.env))
      ..addAll(await loadEnvs('${env.path}.env'))
      ..addAll(await loadEnvs('${env.path}.private.env'));
  }
}
