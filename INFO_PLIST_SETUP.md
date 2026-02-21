# Info.plist Ayarları

## Xcode'da Info.plist'e Eklenmesi Gerekenler

Xcode'da aşağıdaki adımları izleyin:

### Yöntem 1: Xcode UI Üzerinden

1. Project Navigator'da proje dosyanızı (GourmeAfterAll.xcodeproj) seçin
2. TARGETS altında "GourmeAfterAll"ı seçin
3. "Info" sekmesine geçin
4. "Custom iOS Target Properties" bölümünde "+" butonuna tıklayın
5. Aşağıdaki değerleri ekleyin:

#### Konum İzinleri

| Key | Value |
|-----|-------|
| Privacy - Location When In Use Usage Description | GourmeAfterAll yakınınızdaki harika restoranları bulmanız için konumunuza ihtiyaç duyar. |
| Privacy - Location Always and When In Use Usage Description | GourmeAfterAll size özel restoran önerileri sunmak için konumunuzu kullanır. |

### Yöntem 2: Info.plist Dosyasını Doğrudan Düzenleme

Eğer Info.plist dosyasını direkt olarak düzenlemek isterseniz:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>GourmeAfterAll yakınınızdaki harika restoranları bulmanız için konumunuza ihtiyaç duyar.</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>GourmeAfterAll size özel restoran önerileri sunmak için konumunuzu kullanır.</string>
```

## Kontrol Listesi

- [ ] Google Places API Key alındı
- [ ] NetworkManager.swift içinde API key güncellendi
- [ ] Info.plist'e konum izinleri eklendi
- [ ] Tüm dosyalar Xcode projesine eklendi
- [ ] Proje başarıyla derleniyor
- [ ] Simulator'da konum ayarları yapıldı

## Simulator'da Test İçin

Simulator'da konum testi için:

1. Simulator'ı çalıştırın
2. Features → Location → Custom Location...
3. İstanbul için: Latitude: 41.0082, Longitude: 28.9784
4. Veya "Apple" preset lokasyonlarından birini seçin

## Sorun Giderme

### "Location permission denied" hatası
- Info.plist'te izin açıklamalarını kontrol edin
- Simulator'da Settings → Privacy & Security → Location Services açık olmalı
- Uygulamayı sıfırlayın: Settings → General → Reset → Reset Location & Privacy

### "API key not valid" hatası
- Google Cloud Console'da API key'in doğru olduğundan emin olun
- Places API'nin etkinleştirildiğini kontrol edin
- API key'de iOS bundle ID kısıtlaması varsa kontrol edin

### Restoranlar yüklenmiyor
- İnternet bağlantısını kontrol edin
- Konum servislerinin çalıştığından emin olun
- Console loglarını kontrol edin
