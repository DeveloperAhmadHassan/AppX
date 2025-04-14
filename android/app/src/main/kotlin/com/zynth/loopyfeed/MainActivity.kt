package com.zynth.loopyfeed

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.core.content.ContextCompat

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "custom.notification.channel")
            .setMethodCallHandler { call, result ->
                if (call.method == "showNotification") {
                    val title = call.argument<String>("title") ?: "Title"
                    val message = call.argument<String>("message") ?: "Message"
                    showCustomNotification(title, message)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun showCustomNotification(title: String, message: String) {
        val channelId = "custom_channel_id"
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Custom Notification Channel",
                NotificationManager.IMPORTANCE_HIGH
            )
            notificationManager.createNotificationChannel(channel)
        }

//        val customView = RemoteViews(packageName, R.layout.custom_notification)
//        customView.setTextViewText(R.id.notification_title, title)
//        customView.setTextViewText(R.id.notification_text, message)

        val notificationLayout = RemoteViews(packageName, R.layout.notification_small)
        val notificationLayoutExpanded = RemoteViews(packageName, R.layout.notification_large)

        val builder = NotificationCompat.Builder(this, channelId)
            .setSmallIcon(R.drawable.ic_stat_logo_hd) // fallback icon
            .setContentTitle("Notification Title")
            .setContentText("Notification Text")
            .setColor(ContextCompat.getColor(this, R.color.color_accent)) // Use color from colors.xml
            .setColorized(true)   // Enable background color
            .build()

        notificationManager.notify(1, builder)
    }
}
