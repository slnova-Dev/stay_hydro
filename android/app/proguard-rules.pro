# ==========================================
# [STAYHYDRO PROGUARD RULES]
# اردو کمنٹ:
# flutter_local_notifications + Gson TypeToken crash fix
# Boot receiver restore crash: Missing type parameter
# ==========================================

-keepattributes Signature
-keepattributes *Annotation*

-keep class com.google.gson.reflect.TypeToken { *; }
-keep class com.google.gson.** { *; }

# flutter_local_notifications boot receiver / scheduled notification restore
-keep class com.dexterous.flutterlocalnotifications.** { *; }