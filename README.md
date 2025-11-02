# walkapp

Minimal Flutter adım sayar uygulaması.

## Adımlar (Codemagic ile)

1) Bu klasörü GitHub deponuza yükleyin (root’ta `pubspec.yaml`, `lib/`, `codemagic.yaml` olmalı).
2) Codemagic’te uygulamanıza girip **Switch to YAML configuration** deyin; repo kökündeki `codemagic.yaml` otomatik algılanır.
3) Workflow olarak **Android APK (walkapp)**’ı seçip **Start new build**.
4) Bitince **Artifacts** kısmından **app-debug.apk** dosyasını indirin.

> Not: Adım sensörü sadece gerçek cihazda çalışır. ACTIVITY_RECOGNITION izni istenir.
