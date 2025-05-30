import Flutter
import UIKit

import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // notification...
    FlutterLocalNotificationsPlugin.setPluginRegistrationCallback{(registry) in
    GeneratedPluginRegistrant.register(with: register)}

    GeneratedPluginRegistrant.register(with: self)

    // notifications
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
