# GourmeAfterAll 🍽️

**"Nerede Yesem?"** sorusuna eğlenceli bir çözüm!

## Özellikler

✨ **Karar Çarkı**: Yakınındaki restoranları gösteren interaktif, animasyonlu çark  
📍 **Konum Tabanlı**: Google Places API ile 4.0+ puanlı restoranlar  
❤️ **Favoriler**: Beğendiğin restoranları kaydet ve değerlendir  
🎯 **Mystery Spot**: Sürpriz restoran keşfet  
💫 **Haptic Feedback**: Her adımda dokunsal geri bildirim  
🗺️ **Harita Entegrasyonu**: Restoranı haritada gör ve yol tarifi al

## Teknolojiler

- **SwiftUI**: Modern, deklaratif UI
- **SwiftData**: Yerel veri saklama
- **CoreLocation**: Konum servisleri
- **MapKit**: Harita görünümleri
- **Google Places API**: Restoran verisi

## Kurulum

### 1. Google Places API Key

1. [Google Cloud Console](https://console.cloud.google.com/) üzerinden bir proje oluşturun
2. "Places API" ve "Maps SDK for iOS" aktivasyonunu yapın
3. API Key oluşturun
4. `NetworkManager.swift` dosyasında API key'inizi güncelleyin:

```swift
private let apiKey = "YOUR_GOOGLE_PLACES_API_KEY_HERE"
```

### 2. Info.plist Ayarları

Xcode'da Info.plist dosyasını açın ve aşağıdaki key'leri ekleyin:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>GourmeAfterAll yakınınızdaki harika restoranları bulmanız için konumunuza ihtiyaç duyar.</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>GourmeAfterAll size özel restoran önerileri sunmak için konumunuzu kullanır.</string>
```

Alternatif olarak, Xcode'da:
1. Project Navigator'da proje dosyanızı seçin
2. Target'ı seçin (GourmeAfterAll)
3. "Info" sekmesine gidin
4. "Custom iOS Target Properties" bölümüne aşağıdaki key'leri ekleyin:
   - `Privacy - Location When In Use Usage Description`
   - Değer: "GourmeAfterAll yakınınızdaki harika restoranları bulmanız için konumunuza ihtiyaç duyar."

### 3. Xcode'a Dosyaları Ekleme

Oluşturulan dosyalar fiziksel olarak klasörlere yerleştirilmiştir. Xcode'da görebilmek için:

1. Xcode'u açın
2. Project Navigator'da "GourmeAfterAll" üzerine sağ tıklayın
3. "Add Files to GourmeAfterAll..." seçin
4. Aşağıdaki klasörleri seçin:
   - `Models`
   - `Views`
   - `ViewModels`
   - `Services`
   - `Components`
   - `Utilities`
5. **"Create groups"** seçeneğini işaretleyin
6. "Add" butonuna tıklayın

## Proje Yapısı

```
GourmeAfterAll/
├── Models/
│   ├── Restaurant.swift           # Ana restoran modeli
│   └── PlacesResponse.swift       # Google Places API response modelleri
├── Views/
│   ├── HomeView.swift            # Ana ekran
│   ├── FavoritesView.swift       # Favoriler ekranı
│   └── RestaurantDetailView.swift # Detay ekranı
├── ViewModels/
│   ├── HomeViewModel.swift       # Ana ekran view model
│   └── FavoritesViewModel.swift  # Favoriler view model
├── Services/
│   ├── NetworkManager.swift      # API istekleri
│   └── LocationManager.swift     # Konum servisleri
├── Components/
│   ├── SpinningWheel.swift       # Karar çarkı komponenti
│   └── RestaurantCard.swift      # Restoran kartı
└── Utilities/
    ├── HapticManager.swift       # Haptic feedback yönetimi
    └── Constants.swift           # Uygulama sabitleri
```

## Kullanım

1. **İlk Açılış**: Uygulama konum izni isteyecek
2. **Yükleme**: Yakındaki restoranlar otomatik yüklenecek
3. **Çark**: "ÇEVİR!" butonuna bas ve şansını dene
4. **Sonuç**: Çıkan restoranın detaylarını gör
5. **Favoriler**: Beğendiğin restoranları kaydet ve değerlendir

## Mimari

### MVVM (Model-View-ViewModel)

- **Models**: Veri yapıları ve iş mantığı
- **Views**: SwiftUI UI bileşenleri
- **ViewModels**: View ile Model arasında köprü, state yönetimi

### SwiftData

Restaurant modeli SwiftData `@Model` makrosu kullanarak otomatik olarak persist ediliyor.

### Observable Pattern

ViewModels `@Observable` makrosu ile reactive state yönetimi sağlıyor.

## Özelleştirmeler

### Renk Teması

Ana renkler: Turuncu ve Kırmızı gradient'leri
`SpinningWheel.swift` içinde `colors` array'ini özelleştirebilirsiniz.

### Arama Yarıçapı

`AppConstants.swift` içinde `defaultSearchRadius` değerini değiştirebilirsiniz (metre cinsinden).

### Minimum Rating

`AppConstants.swift` içinde `minimumRating` değerini ayarlayabilirsiniz.

## İleride Eklenebilecek Özellikler

- [ ] Mystery Spot özelliği (yüksek puanlı ama gizli restoran)
- [ ] Filtreler (mutfak türü, fiyat aralığı)
- [ ] Arkadaşlarla paylaşma
- [ ] Restoran geçmişi
- [ ] Push bildirimler (yeni restoranlar)
- [ ] Dark mode iyileştirmeleri
- [ ] Offline mod

## Gereksinimler

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Lisans

Bu proje eğitim amaçlı oluşturulmuştur.

---

**Afiyet olsun! 🍽️✨**
