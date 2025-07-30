import 'dart:io';

class EnvConfig {
  static const String _defaultAviationStackKey = 'ce04d84a5463440fe816b2aefc342ec';
  
  /// Get Aviation Stack API key from environment or use default
  static String get aviationStackApiKey {
    return Platform.environment['AVIATION_STACK_API_KEY'] ?? _defaultAviationStackKey;
  }
  
  /// Get Firebase API key from environment
  static String get firebaseApiKey {
    return Platform.environment['FIREBASE_API_KEY'] ?? '';
  }
  
  /// Get Firebase project ID from environment
  static String get firebaseProjectId {
    return Platform.environment['FIREBASE_PROJECT_ID'] ?? 'airway-ally';
  }
  
  /// Check if running in development mode
  static bool get isDevelopment {
    return Platform.environment['FLUTTER_ENV'] == 'development' || 
           Platform.environment['FLUTTER_ENV'] == null;
  }
  
  /// Check if running in production mode
  static bool get isProduction {
    return Platform.environment['FLUTTER_ENV'] == 'production';
  }
} 