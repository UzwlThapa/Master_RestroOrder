# Retrofit / Gson / OkHttp
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**
-dontwarn javax.annotation.**

# Gson reflectively touches our DTOs: keep every field name (server JSON keys are case-sensitive)
-keep class com.danfe.restroorder.waiter.data.model.** { *; }
-keepattributes Signature
-keepattributes *Annotation*

# Retrofit interfaces are proxied; keep their generic signatures
-keepattributes InnerClasses,EnclosingMethod
-keepclassmembers,allowobfuscation interface * {
    @retrofit2.http.* <methods>;
}
-dontwarn retrofit2.KotlinExtensions
-dontwarn retrofit2.KotlinExtensions$*

# Play Services code scanner
-ignorewarnings
