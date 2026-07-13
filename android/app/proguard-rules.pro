# flutter_local_notifications sérialise les notifications planifiées avec GSON.
# Le plugin ne fournit pas ses propres règles R8 : en build release (minification
# activée par défaut par le plugin Gradle de Flutter), les types génériques sont
# effacés et TOUT appel à zonedSchedule()/cancel() plante ensuite avec
# « java.lang.RuntimeException: Missing type parameter ».
# Symptômes observés sans ces règles : boutons « Abandonner » / « Remplacer »
# inopérants (l'annulation de la notification échouait avant la navigation) et
# notifications de fin de repos jamais délivrées en arrière-plan.
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Règles GSON (gson 2.8.9 n'embarque pas ses règles consumer).
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}
