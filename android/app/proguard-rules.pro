# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Flutter Play Core / Deferred Components
-dontwarn com.google.android.play.core.**

# Google Mobile Ads
-keep public class com.google.android.gms.ads.** {
    public *;
}
-keep public class com.google.ads.** {
    public *;
}
