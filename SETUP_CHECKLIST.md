# 🎉 GourmeAfterAll Projesi Kurulum Kontrol Listesi

## ✅ Tamamlanan İşlemler

### 1. Proje Yapısı
- [x] Models klasörü ve dosyaları oluşturuldu
- [x] Views klasörü ve dosyaları oluşturuldu
- [x] ViewModels klasörü ve dosyaları oluşturuldu
- [x] Services klasörü ve dosyaları oluşturuldu
- [x] Components klasörü ve dosyaları oluşturuldu
- [x] Utilities klasörü ve dosyaları oluşturuldu

### 2. Oluşturulan Dosyalar (14 Swift Dosyası)

#### Models
- [x] `Restaurant.swift` - SwiftData model
- [x] `PlacesResponse.swift` - API response models

#### Services
- [x] `NetworkManager.swift` - Google Places API
- [x] `LocationManager.swift` - CoreLocation wrapper

#### ViewModels
- [x] `HomeViewModel.swift`
- [x] `FavoritesViewModel.swift`

#### Views
- [x] `HomeView.swift`
- [x] `FavoritesView.swift`
- [x] `RestaurantDetailView.swift`

#### Components
- [x] `SpinningWheel.swift` - Animasyonlu karar çarkı
- [x] `RestaurantCard.swift`

#### Utilities
- [x] `HapticManager.swift`
- [x] `Constants.swift`

#### App
- [x] `GourmeAfterAllApp.swift` - Güncellendi

### 3. Dokümantasyon
- [x] `README.md` - Detaylı proje kılavuzu
- [x] `INFO_PLIST_SETUP.md` - Kurulum talimatları
- [x] `PROJECT_SUMMARY.md` - Proje özeti
- [x] `SETUP_CHECKLIST.md` - Bu dosya

## 🚀 Xcode'da Yapılması Gerekenler

### Adım 1: Dosyaları Xcode Projesine Ekle

1. Xcode'u açın ve GourmeAfterAll.xcodeproj dosyasını açın
2. Project Navigator'da (sol panel) "GourmeAfterAll" klasörüne sağ tıklayın
3. "Add Files to GourmeAfterAll..." seçeneğini seçin
4. Şu klasörleri seçin:
   - [ ] Models
   - [ ] Views
   - [ ] ViewModels
   - [ ] Services
   - [ ] Components
   - [ ] Utilities
5. **ÖNEMLİ:** "Create groups" seçeneğini işaretleyin (klasör simgesine sahip)
6. "Copy items if needed" seçeneğini KALDIIRIN (dosyalar zaten projede)
7. Target'in "GourmeAfterAll" olduğundan emin olun
8. "Add" butonuna tıklayın

### Adım 2: Info.plist Ayarlarını Yap

#### Yöntem A: Xcode UI (Önerilen)
1. Project Navigator'da proje dosyasını seçin (mavi ikon)
2. TARGETS bölümünde "GourmeAfterAll"ı seçin
3. "Info" sekmesine geçin
4. "Custom iOS Target Properties" altında "+" butonuna tıklayın
5. Aşağıdaki key'leri ekleyin:

```
Privacy - Location When In Use Usage Description
Değer: GourmeAfterAll yakınınızdaki harika restoranları bulmanız için konumunuza ihtiyaç duyar.
```

#### Yöntem B: Info.plist Dosyasını Direkt Düzenle
1. Project Navigator'da Info.plist dosyasını bulun
2. Sağ tıklayın → "Open As" → "Source Code"
3. `<dict>` tag'i içine aşağıdaki satırları ekleyin:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>GourmeAfterAll yakınınızdaki harika restoranları bulmanız için konumunuza ihtiyaç duyar.</string>
```

### Adım 3: Google Places API Key

1. [ ] Google Cloud Console'da proje oluştur
2. [ ] Places API'yi etkinleştir
3. [ ] API Key oluştur
4. [ ] `Services/NetworkManager.swift` dosyasını aç
5. [ ] 17. satırdaki `YOUR_GOOGLE_PLACES_API_KEY_HERE` yerine kendi API key'ini yaz:

```swift
private let apiKey = "AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```

### Adım 4: Build & Test

1. [ ] Cmd+B ile projeyi derle
2. [ ] Hata varsa düzelt
3. [ ] Simulator seç (iPhone 15 Pro önerilir)
4. [ ] Cmd+R ile çalıştır
5. [ ] Konum izni iste ve "Allow While Using App" seç

### Adım 5: Simulator Konum Ayarı

1. [ ] Simulator'da Features → Location → Custom Location...
2. [ ] İstanbul için: Latitude: `41.0082`, Longitude: `28.9784`
3. [ ] Veya "Apple" preset lokasyonunu seç

## 🔍 Sorun Giderme

### Derleme Hataları

#### "Cannot find X in scope"
- Tüm dosyaların Xcode projesine eklendiğinden emin olun
- Clean Build Folder (Cmd+Shift+K) yapın
- Projeyi tekrar derleyin (Cmd+B)

#### "Missing SwiftData symbols"
- Deployment Target'in iOS 17.0+ olduğundan emin olun
- Project → Target → General → Minimum Deployments

#### Import hataları
- Tüm import statement'ların doğru olduğundan emin olun
- `import SwiftUI`, `import SwiftData`, `import CoreLocation`, `import MapKit`

### Çalışma Zamanı Hataları

#### "Location permission denied"
- Info.plist'e konum izin açıklamalarını eklediniz mi?
- Simulator Settings → Privacy & Security → Location Services açık mı?
- Reset: Device → Erase All Content and Settings...

#### "API key not valid"
- API key doğru mu?
- Google Cloud Console'da Places API aktif mi?
- Bundle ID kısıtlaması varsa doğru mu?

#### "No restaurants found"
- İnternet bağlantısı var mı?
- Konum servisleri çalışıyor mu?
- API key geçerli mi?
- Console loglarını kontrol edin

## 🎨 Özelleştirme İpuçları

### Renkleri Değiştir
- `Components/SpinningWheel.swift` → `colors` array'i
- Views'larda `.orange` ve `.red` renkleri

### Arama Yarıçapını Değiştir
- `Utilities/Constants.swift` → `defaultSearchRadius`

### Minimum Rating Değiştir
- `Utilities/Constants.swift` → `minimumRating`

## 📱 Test Senaryoları

1. [ ] İlk açılışta konum izni isteniyor
2. [ ] Restoranlar yükleniyor
3. [ ] Çark dönüyor ve rastgele restoran seçiliyor
4. [ ] Seçilen restoran kartı gösteriliyor
5. [ ] Favorilere ekleme çalışıyor
6. [ ] Favoriler sayfası açılıyor
7. [ ] Restoran detay sayfası açılıyor
8. [ ] Haritada göster çalışıyor
9. [ ] Değerlendirme sistemi çalışıyor
10. [ ] Haptic feedback hissediliyor

## ✨ Öne Çıkan Özellikler

- 🎡 **Animasyonlu Çark**: 3 saniye smooth rotation
- 📍 **Konum Bazlı**: CoreLocation entegrasyonu
- ❤️ **Favori Sistemi**: SwiftData ile persist
- ⭐ **Değerlendirme**: Kullanıcı puanlama sistemi
- 🗺️ **Harita**: MapKit entegrasyonu
- 📱 **Haptic**: Her interaksiyonda feedback
- 🎨 **Modern UI**: Apple-style tasarım
- 🔄 **MVVM**: Clean architecture

## 📚 Ek Kaynaklar

- Apple SwiftUI Docs: https://developer.apple.com/documentation/swiftui
- SwiftData Guide: https://developer.apple.com/documentation/swiftdata
- Google Places API: https://developers.google.com/maps/documentation/places/web-service
- CoreLocation: https://developer.apple.com/documentation/corelocation

---

**Hazırsınız! Afiyet olsun! 🍽️✨**
