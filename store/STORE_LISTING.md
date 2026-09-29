# Diatom-AI — Store Listing Kit

Copy-paste text for App Store Connect and Google Play Console. The character limit for each field is in brackets and every text below fits its limit.

Items in `[[double brackets]]` need your input before submitting.

**Primary language:** Indonesian (the app UI is Indonesian). An English localization is included for both stores.

---

## 0. Before you submit

- [ ] Deploy the backend so that `https://diato-ai.fajrsyauqi.com/privacy-policy` is live (the page is `resources/views/privacy-policy.blade.php` and the route is in `routes/web.php`).
- [ ] Check the contact email in the privacy policy (currently `fajrudinsauqi@gmail.com`).
- [ ] Increase `version:` in `pubspec.yaml` for every upload (`1.0.0+1`, then `1.0.0+2`, and so on).
- [ ] Android: `flutter build appbundle --release`, then upload `build/app/outputs/bundle/release/app-release.aab`.
- [ ] iOS: `flutter build ipa --release`, then upload `build/ios/ipa/*.ipa` with Transporter or Xcode Organizer.

---

## 1. Shared information

| Field | Value |
|---|---|
| App name | Diatom-AI |
| Bundle ID / package name | `com.diato.diatoAi` |
| Privacy policy URL | https://diato-ai.fajrsyauqi.com/privacy-policy |
| Support / website URL | https://diato-ai.fajrsyauqi.com |
| Support email | [[support email, e.g. fajrudinsauqi@gmail.com]] |
| Primary category | Education |
| Secondary category (App Store) | Reference |
| Price | Free |
| Ads | None |
| In-app purchases | None |
| Login required | No (there are no accounts) |
| Copyright (App Store) | [[© 2026 Universitas Negeri Malang — confirm the rights holder]] |

---

## 2. App Store Connect

### 2.1 Indonesian (primary)

**Name** [30]
```
Diatom-AI
```

**Subtitle** [30]
```
Identifikasi Diatom dengan AI
```

**Promotional text** [170]
```
Foto sel diatom dari mikroskop, dan AI akan mengenali genusnya dalam hitungan detik. Pelajari diatom, jelajahi Sungai Brantas, dan hitung indeks kualitas air BRDI.
```

**Description** [4000]
```
Diatom-AI adalah aplikasi pembelajaran dan penelitian diatom berbasis kecerdasan buatan (Convolutional Neural Network). Aplikasi ini dikembangkan oleh tim akademisi pendidikan biologi dan ekologi perairan Universitas Negeri Malang untuk mahasiswa, pendidik, dan peneliti.

IDENTIFIKASI DIATOM OTOMATIS
Potret sel diatom langsung dari mikroskop atau pilih citra dari galeri. Model AI akan mengenali genus diatom dan menampilkan kandidat teratas beserta tingkat keyakinannya. Jika foto tidak memuat diatom, aplikasi akan memberi tahu Anda.

BELAJAR TENTANG DIATOM
Pelajari karakteristik, struktur sel, morfologi, dan klasifikasi kelas Bacillariophyceae melalui materi yang tersusun rapi, lengkap dengan gambar dan video. Tersedia juga panduan prosedur pengambilan dan identifikasi sampel diatom.

KATALOG SPESIES
Telusuri katalog spesies diatom beserta deskripsi, nilai sensitivitas, dan nilai indikatornya.

PETA SEBARAN DIATOM SUNGAI BRANTAS
Lihat lokasi stasiun pengambilan sampel di sepanjang Sungai Brantas, kondisi lingkungannya, dan komunitas diatom yang ditemukan di setiap stasiun.

KALKULATOR INDEKS KUALITAS AIR (BRDI)
Hitung Brantas River Diatom Index (BRDI) dari komposisi komunitas diatom yang Anda temukan, lalu simpan hasil perhitungan untuk dibandingkan kemudian.

MENDUKUNG PEMBELAJARAN
Diatom-AI dirancang dalam kerangka Generative Pedagogy – Microalgae Identification Learning dengan tahapan Constructing, Investigating, dan Interpreting.

TANPA AKUN
Tidak perlu mendaftar atau masuk. Langsung buka dan gunakan.

Catatan: hasil identifikasi AI adalah alat bantu belajar dan penelitian. Konfirmasikan hasil penting dengan identifikasi morfologi oleh ahli.
```

**Keywords** [100] (comma-separated, no spaces)
```
diatom,mikroalga,mikroskop,biologi,ekologi,kualitas air,sungai,brantas,protista,identifikasi,alga
```

**What's New in This Version** [4000]
```
Rilis pertama Diatom-AI.
```

### 2.2 English localization

**Name** [30]
```
Diatom-AI
```

**Subtitle** [30]
```
AI Diatom Identification
```

**Promotional text** [170]
```
Photograph a diatom cell through your microscope and the AI names its genus in seconds. Learn about diatoms, explore the Brantas River, and calculate the BRDI index.
```

**Description** [4000]
```
Diatom-AI is a learning and research app for diatoms, powered by a convolutional neural network. It was developed by an academic team in biology education and aquatic ecology at Universitas Negeri Malang (State University of Malang, Indonesia) for students, educators, and researchers.

AUTOMATIC DIATOM IDENTIFICATION
Take a photo of a diatom cell through the microscope or pick an image from your gallery. The AI model identifies the diatom genus and shows the top candidates with their confidence. If the photo holds no diatom, the app tells you.

LEARN ABOUT DIATOMS
Study the characteristics, cell structure, morphology, and classification of the class Bacillariophyceae through structured lessons with images and videos. Step-by-step guides for sampling and identifying diatoms are included.

SPECIES CATALOGUE
Browse a catalogue of diatom species with descriptions, sensitivity values, and indicator values.

BRANTAS RIVER DISTRIBUTION MAP
See the sampling stations along the Brantas River, their environmental conditions, and the diatom communities found at each station.

WATER QUALITY INDEX CALCULATOR (BRDI)
Calculate the Brantas River Diatom Index (BRDI) from the diatom community you found, and save your calculations to compare later.

BUILT FOR LEARNING
Diatom-AI follows the Generative Pedagogy – Microalgae Identification Learning framework, with Constructing, Investigating, and Interpreting stages.

NO ACCOUNT NEEDED
No sign-up or login. Open the app and start.

Note: AI identification is a learning and research aid. Confirm important results with morphological identification by an expert.

Most content in the app is in Indonesian.
```

**Keywords** [100]
```
diatom,microalgae,microscope,biology,ecology,water quality,river,plankton,protist,identify,algae
```

**What's New in This Version**
```
First release of Diatom-AI.
```

### 2.3 App Privacy ("nutrition label")

Tracking: **No**. Do not declare any data as "used to track you".

Declare these data types as collected:

| Data type | Linked to user? | Used for tracking? | Purposes |
|---|---|---|---|
| User Content → Photos or Videos | No | No | App Functionality, Other Purposes (research to improve the identification model) |
| User Content → Other User Content (location names and counts in saved BRDI calculations) | No | No | App Functionality |
| Identifiers → Device ID (random installation ID, not IDFA or IDFV) | No | No | App Functionality |

Not collected: contact info, health, financial, location, contacts, browsing history, search history, usage data, diagnostics, purchases.

### 2.4 Age rating questionnaire

Answer **None** or **No** to every question: violence, sexual content, profanity, drugs, gambling, horror, medical information, unrestricted web access, user-generated content shared with others, messaging, contests. The expected result is **4+**.

### 2.5 Export compliance

`ITSAppUsesNonExemptEncryption = false` is set in `Info.plist`, so App Store Connect does not ask about encryption. The app only uses standard HTTPS.

### 2.6 App Review information

**Sign-in required:** No (leave the demo account fields empty).

**Contact:** [[first name]] [[last name]], [[phone]], [[email]]

**Notes** [4000]
```
Diatom-AI has no user accounts; all features are available without signing in.

The main feature identifies diatoms (microscopic algae) in microscope images. To test it without a microscope:
1. Save the attached sample image (review_sample_diatom.jpg) to the device's Photos.
2. Tap the round scan button in the middle of the bottom navigation bar and allow camera access.
3. Choose the gallery option and pick the sample image.
4. The result screen shows the identified genus (Pinnularia) with its confidence.

Photos of anything other than a diatom return a "no diatom detected" message; this is expected.

Camera access is used only to photograph diatoms through a microscope. Photo library access is used only to pick an existing microscope image. The selected image is uploaded to our server (https://diato-ai.fajrsyauqi.com) for identification.

The app content is in Indonesian. It is an educational app developed by an academic team at Universitas Negeri Malang, Indonesia.
```

**Attachment:** `store/review_sample_diatom.jpg`

### 2.7 Screenshots

| Display | Folder | Size |
|---|---|---|
| iPhone 6.9" (required) | `store/screenshots/iphone_6.9/` | 1320 × 2868 |
| iPad 13" (required because the app runs on iPad) | `store/screenshots/ipad_13/` | 2064 × 2752 |

Upload in file order (01 to 07). App Store Connect scales these down for the smaller displays.

---

## 3. Google Play Console

### 3.1 Main store listing — Indonesian (default language: `id-ID`)

**App name** [30]
```
Diatom-AI: Identifikasi Diatom
```

**Short description** [80]
```
Identifikasi diatom dari foto mikroskop dengan AI, plus kalkulator indeks BRDI.
```

**Full description** [4000]

Use the Indonesian App Store description from section 2.1.

### 3.2 English translation (`en-US`)

**App name** [30]
```
Diatom-AI: Diatom Identifier
```

**Short description** [80]
```
Identify diatoms in microscope photos with AI, and calculate the BRDI index.
```

**Full description** [4000]

Use the English App Store description from section 2.2.

### 3.3 Graphics

| Asset | File | Size |
|---|---|---|
| App icon | `store/graphics/play_icon_512.png` | 512 × 512 |
| Feature graphic | `store/graphics/play_feature_graphic_1024x500.png` | 1024 × 500 |
| Phone screenshots | `store/screenshots/android_phone/` | 1080 × 2160 |
| 7" and 10" tablet screenshots | Optional. You can upload `store/screenshots/ipad_13/` (Play accepts them) or skip. |

### 3.4 Store settings

- **App category:** Education
- **Tags:** Education, Science, Reference
- **Contact email:** [[support email]]
- **Website:** https://diato-ai.fajrsyauqi.com

### 3.5 App content (Policy → App content)

**Privacy policy:** https://diato-ai.fajrsyauqi.com/privacy-policy

**Ads:** No, the app does not contain ads.

**App access:** All functionality is available without special access.

**Content rating (IARC questionnaire):**
- Email: [[email]]
- Category: **Reference, News, or Educational**
- Answer **No** to violence, sexuality, language, controlled substances, gambling, and user interaction/sharing questions. The app does not share user location and does not allow users to interact or exchange content with each other.
- Expected result: **Everyone / 3+ (PEGI 3)**

**Target audience and content:**
- Target age groups: **16–17** and **18 and over**
- Appeals to children: **No**

**News app:** No

**COVID-19 contact tracing / status app:** No

**Data safety:**

| Question | Answer |
|---|---|
| Does your app collect or share any of the required user data types? | Yes |
| Is all of the user data collected by your app encrypted in transit? | Yes |
| Do you provide a way for users to request that their data is deleted? | Yes (by email, as described in the privacy policy) |

Data types to declare:

| Data type | Collected | Shared | Processed ephemerally? | Required or optional | Purposes |
|---|---|---|---|---|---|
| Photos and videos → Photos | Yes | No | No | Optional (users choose to scan) | App functionality |
| App activity → Other user-generated content (saved BRDI calculations) | Yes | No | No | Optional | App functionality |
| Device or other IDs (random installation ID) | Yes | No | No | Required | App functionality |

Everything else: not collected.

**Government app:** No
**Financial features:** None
**Health apps:** No

### 3.6 Release notes (`<id-ID>` / `<en-US>`)
```
<id-ID>
Rilis pertama Diatom-AI.
</id-ID>
<en-US>
First release of Diatom-AI.
</en-US>
```

### 3.7 Testing before production

New personal developer accounts must run a **closed test with at least 12 testers for 14 consecutive days** before Google allows a production release. Organization accounts skip this.

---

## 4. Screenshot captions

Use these if you add text overlays in a tool such as Figma or AppLaunchpad. The raw screenshots do not have captions.

| # | File | Indonesian | English |
|---|---|---|---|
| 1 | `01_home` | Selamat datang di Diatom-AI | Welcome to Diatom-AI |
| 2 | `02_scan_result` | Kenali genus diatom dengan AI | Identify diatom genera with AI |
| 3 | `03_explore` | Pelajari dunia diatom | Explore the world of diatoms |
| 4 | `04_content` | Materi lengkap dan terstruktur | Structured lessons |
| 5 | `05_map` | Peta sebaran diatom Sungai Brantas | Brantas River distribution map |
| 6 | `06_calculator` | Hitung indeks kualitas air BRDI | Calculate the BRDI water-quality index |
| 7 | `07_about` | Dikembangkan oleh Universitas Negeri Malang | Developed at Universitas Negeri Malang |

---

## 5. Regenerating screenshots

The screenshots come from `integration_test/store_screenshots_test.dart`. To regenerate them after UI changes, run:

```sh
# iPhone 6.9"
SCREENSHOT_DIR=iphone_6.9 flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/store_screenshots_test.dart -d "iPhone 17 Pro Max"

# iPad 13"
SCREENSHOT_DIR=ipad_13 flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/store_screenshots_test.dart -d "iPad Pro 13-inch (M5)"

# Android phone: Play needs a ratio of at most 2:1, so set the emulator to 1080x2160 first
adb shell wm size 1080x2160
SCREENSHOT_DIR=android_phone flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/store_screenshots_test.dart -d emulator-5554
adb shell wm size reset
```

Each run uploads the sample image to the production API, which stores one scan record.

The driver saves PNGs with an alpha channel, and App Store Connect rejects those. Flatten them before uploading:

```sh
python3 -c "
from PIL import Image; import glob
for f in glob.glob('store/screenshots/*/*.png'):
    Image.open(f).convert('RGB').save(f)"
```
