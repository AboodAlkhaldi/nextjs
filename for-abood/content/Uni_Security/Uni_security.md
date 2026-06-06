# 🔐 Güvenlik Mühendisliği — Tam Çalışma Rehberi
### Tek Bilgi Kaynağı | Final Sınavı Baskısı

> **Sınav odağı:** Tüm konular sorulabilir. Ağırlık, **vize sonrası** işlenen konulardadır (Hafta 8, 10, 11, Hash Fonksiyonları, SQL Injection). Vize konuları (Hafta 1–5) sınavda daha az ağırlıkla bulunur.

---

## 📋 İÇİNDEKİLER

**BÖLÜM A — TEMELLER (Vize Konuları)**
1. [Hafta 1 — Güvenlik Mühendisliğine Giriş](#hafta-1)
2. [Hafta 2 — Tehdit Aktörleri ve Tehdit Modelleme](#hafta-2)
3. [Hafta 3 — Güvenlik Protokolleri ve Kimlik Doğrulama I](#hafta-3)
4. [Hafta 4 — İleri Kimlik Doğrulama Mekanizmaları](#hafta-4)
5. [Hafta 5 — Mesaj Manipülasyonu ve Gerçek Dünya Saldırıları](#hafta-5)

**BÖLÜM B — VİZE SONRASI KONULAR (Ağır Ağırlık)**

6. [Hafta 8 — Mesaj Manipülasyonu, Anahtar Yönetimi ve Protokoller](#hafta-8)
7. [Hafta 10 — Kriptografinin Temelleri](#hafta-10)
8. [Klasik Şifreler (Kriptografi Sunum)](#klasik)
9. [Hafta 11 — AES Güvenliği ve Çalışma Modları](#hafta-11)
10. [Hash Fonksiyonları](#hash)
11. [SQL Injection — app2.py ve app3.py](#sqli)

**DENEME SINAVI**

12. [Deneme Sınavı (20 Soru)](#sinav)
13. [Cevaplar](#cevaplar)

---

# BÖLÜM A — TEMELLER

---

<a name="hafta-1"></a>
## HAFTA 1 — Güvenlik Mühendisliğine Giriş

### Güvenlik Mühendisliği Nedir?

Güvenlik mühendisliği; **kötü niyetli aktörlerin, hataların ve beklenmedik durumların varlığında bile güvenilir ve sağlam çalışmaya devam edebilen sistemler tasarlama** bilimidir. Bu alan yalnızca teknoloji ile sınırlı değildir — insan davranışlarını, organizasyonu ve ekonomik teşvikleri de eşit ölçüde kapsar.

**Günümüzdeki önemi:**
- Dijitalleşme güvenliği finans, sağlık, savunma ve enerji gibi her sektörde kritik hale getirmiştir.
- Modern tehditler iyi finanse edilmiş, sabırlı ve stratejik düşünen rakiplerden gelir.
- Başarısızlıklar yalnızca BT sistemlerini değil, gerçek insan hayatlarını etkiler (zincirleme etki: bir ülkenin bankacılık sistemi çökerse tüm ekonomisi zarar görür).

---

### Güvenlik Mühendisliği ile Sistem Mühendisliği Karşılaştırması

| Boyut | Sistem Mühendisliği | Güvenlik Mühendisliği |
|---|---|---|
| Temel kaygı | Kazasal arızalar, yazılım hataları | Kasıtlı, kötü niyetli saldırılar |
| Rakip | Yok (sadece şanssızlık) | Akıllı ve uyarlanabilir saldırgan |
| Tasarım yaklaşımı | Güvenilirlik odaklı | Düşmanca düşünme gerektirir |

Modern yazılım sistemlerinde bu iki alan iç içe geçmiştir. Bir yazılım hatası güvenlik açığına, bir güvenlik açığı da yazılım hatasına dönüşebilir.

---

### Güvenlik Çerçevesi — 4 Temel Bileşen

Gerçek bir güvenlik sistemi, bu **dördünün** birlikte çalışmasını gerektirir:

1. **Politika (Policy)** — *Neyin* korunacağını ve hangi güvenlik hedeflerinin izleneceğini tanımlar. Risk önceliklerini belirler. Yanlış politika = mekanizmalar ne kadar iyi olursa olsun başarısızlık. ⚠️ *11 Eylül örneği: mekanizmalar (X-ray, güvenlik kontrolleri) çalışıyordu; ancak politika yanlıştı — tehdit olarak alışılmış suç öngörülmüştü, uçağın kendisinin bir silah olarak kullanılacağı değil.*

2. **Mekanizma (Mechanism)** — *Nasıl* korunacağını belirler. Teknik çözümler: şifreleme, erişim kontrolü, güvenlik duvarları, biyometri. Mekanizmalardaki karmaşıklık risk yaratır.

3. **Güvence (Assurance)** — Mekanizmalara *ne kadar* güvenilebileceği. Test, sızma testleri, sertifikasyonlar ve denetimler aracılığıyla doğrulanır. **Sızma testi (pentest):** etik hackerların gerçek bir saldırgan gibi davranarak sisteme sızmaya çalıştığı, gerçek saldırılar olmadan önce zayıflıkları bulan test sürecidir.

4. **Teşvik (Incentives)** — İnsanların kurallara *neden* uyduğu ya da uymadığı. Güvenlik politikalarını can sıkıcı bulan çalışanlar geçici çözümler arar. Saldırganlar kendi ekonomik teşvikleriyle hareket eder. Sistemler insan motivasyonunu hesaba katmalıdır.

---

### Temel Güvenlik Özellikleri (CIA + AAA)

| Özellik | Türkçe | Anlamı |
|---|---|---|
| **Confidentiality** | Gizlilik | Yalnızca yetkili taraflar veriye erişebilir |
| **Integrity** | Bütünlük | Veri, fark edilmeden değiştirilemez |
| **Availability** | Erişilebilirlik | Sistem ve veriler gerektiğinde ulaşılabilirdir |
| **Authentication** | Kimlik Doğrulama | Birinin *kim* olduğunu doğrular |
| **Authorization** | Yetkilendirme | Birinin *ne yapabileceğini* doğrular |
| **Accountability** | Hesap Verebilirlik | Eylemler sorumlu bir tarafa izlenebilir |

---

### Emniyet (Safety) ve Güvenlik (Security) Farkı

- **Safety (Emniyet):** *Kazalara ve rastgele arızalara* karşı koruma
- **Security (Güvenlik):** *Kasıtlı, kötü niyetli saldırılara* karşı koruma
- Modern yazılım güdümlü sistemlerde bu ayrım belirsizleşmiştir — bir güvenlik saldırısı emniyet olayına yol açabilir (ör. bir arabanın frenlerini hacklemek).

---

### Güvenlik Tiyatrosu

Güvenlik tiyatrosu; gerçek riski azaltmayan ama güvenlik sağlıyormuş *gibi görünen* önlemleri ifade eder. Görünür ama etkisiz önlemlere harcanan kaynaklar daha faydalı yerlerde kullanılabilir. Örnek: pek çok havalimanında yolcuların ayakkabılarını çıkarması.

---

### Düşmanca Düşünme

Güvenlik mühendisleri saldırgan gibi düşünmelidir:
- **Saldırganın hedefleri nedir?**
- **Yetenekleri nedir?**
- **En zayıf halka neresidir?**

Çoğu sistemin en zayıf halkası teknoloji değil, **insan davranışıdır**. Kullanıcılar zayıf parola seçer, kimlik avı bağlantılarına tıklar ve kimlik bilgilerini paylaşır. Etkili güvenlik tasarımı gerçek insan davranışını hesaba katmalıdır.

---

### Banka Güvenliği — Örnek Olay

Bankalar hem iç hem de dış tehditlerle karşı karşıyadır:
- **İç tehditler:** Çalışan sahtekârlığı (çift kayıt sistemi, görev ayrımı ve denetim izleriyle çözülür)
- **Dış tehditler:** ATM dolandırıcılığı, kimlik avı, devlet destekli saldırılar
- **Fiziksel:** Alarm sistemleri, şubeler arası şifreli iletişim

**Temel ders:** Çok katmanlı savunma — tek bir mekanizma asla yeterli değildir.

---

<a name="hafta-2"></a>
## HAFTA 2 — Tehdit Aktörleri ve Tehdit Modelleme

### Rakip Kimdir?

Savunma tasarlamadan önce kime karşı savunma yaptığınızı anlamanız gerekir. Güvenlik mühendisliği hem **stratejik hem de analitik** bir disiplindir — salt teknik değil.

**Tehdit Modelleme şu soruları sorar:**
- Bize kim saldırabilir?
- Neden saldırır?
- Nasıl saldırır?
- Ne kazanır?
- Hangi riskler önceliklidir?

---

### Tehdit Aktörlerinin Türleri

**1. Devlet Destekli Saldırganlar (Nation-State)**
En güçlü rakiplerdir. Saldırıları:
- Uzun vadeli ve sabırlıdır
- Hedef odaklı ve gizlidir
- Stratejik motivasyonludur (istihbarat, ekonomik avantaj, askeri üstünlük)
- İyi finanse edilmiş profesyonel ekiplerle yürütülür

Edward Snowden'ın ifşaatıyla ortaya çıkan programlar:
- **PRISM** — NSA'nın büyük ABD teknoloji şirketlerinden (Google, Facebook vb.) veri topladığı program
- **TEMPORA** — İngiltere'nin GCHQ ajansının fiber optik kabloları dinlediği ve büyük ölçekte trafik topladığı program. **Metadata analizi:** içerik okunmasa da *kimin kiminle, ne zaman, nereden* iletişim kurduğu analiz edilir
- **MUSCULAR** — NSA ve GCHQ'nun Google ve Yahoo'nun veri merkezleri arasındaki özel ağ trafiğini gizlice izlediği program
- **XKeyscore** — NSA'nın internet trafiğini analiz ettiği araç: e-postalar, aramalar, sosyal medya, tarayıcı geçmişi
- **Bullrun & Edgehill** — Kriptografi standartlarını kasıtlı olarak *zayıflatan* programlar (rastgele sayı üreticilerine arka kapı, algoritmaları güvensizleştirme)
- **Five Eyes** — İstihbarat paylaşım ittifakı: ABD, İngiltere, Kanada, Avustralya, Yeni Zelanda
- **Longhaul** — VPN kırma + kriptanaliz
- **Quantum** — Tarayıcı istismarı + MITM

**2. Siber Suçlular**
- Finansal motivasyonlu
- Profesyonel, küreselleşmiş, uzmanlaşmış
- Yeraltı pazarları (araçlar, çalıntı veri, hizmet olarak fidye yazılımı)
- Örnekler: Fidye yazılımı, bankacılık trojanları, veri hırsızlığı

**3. Hacktivistler**
- İdeolojik veya siyasi motivasyonlu
- Hedef: kamuoyu baskısı, kesinti veya siyasi mesaj vermek

**4. İç Tehditler (Insider Threat)**
- Mevcut/eski çalışanlar, iş ortakları
- Özellikle tehlikelidir çünkü:
  - ✓ Meşru erişime sahiptirler
  - ✓ Sistemleri ve zafiyetleri tanırlar
  - ✓ Zaten güven kazanmışlardır

---

### Tehdit Modelleme Bileşenleri

| Bileşen | Açıklama |
|---|---|
| **Motivasyon** | Saldırgan ne ister? (para, sır, kesinti) |
| **Kapasite** | Ne gibi kaynakları var? (teknik bilgi, para, insan gücü) |
| **Risk** | Olasılık × Hasarın büyüklüğü |
| **Maliyet** | Her güvenlik önleminin finansal, performans ve kullanılabilirlik maliyeti vardır |

**Temel ilke:** Tüm tehditler bertaraf edilemez. Güvenlik kaynakları **risk önceliği ve maliyet-fayda analizine** göre dağıtılmalıdır.

---

### Tarihsel Tehdit Evrimi

- **İlk dönem:** İzole sistemler, ağ yok, fiziksel erişim gerekli. Tehditler azdı.
- **Hacker kültürü dönemi:** Üniversiteler, hobiciler. Gerçek zarar verme niyeti düşüktü.
- **İnternet dönemi:** Spam, DDoS, kötü yazılım ve dolandırıcılık yaygınlaştı.
- **Modern dönem:** Devlet aktörleri, profesyonel suç örgütleri, fidye yazılımı, tedarik zinciri saldırıları.

---

### İstihbarat Toplama Yöntemleri

- **HUMINT (İnsan İstihbaratı):** İnsan ajanları, muhbirler. Ölçeklendirilmesi zor.
- **SIGINT (Sinyal İstihbaratı):** Elektronik sinyallerin dinlenmesi. Ölçeklenebilir, otomatize.
- **CNE (Bilgisayar Ağı İstismarı):** Sistemlere sızma. Örnek: *Belgacom* saldırısı (NSA/GCHQ Belçika'nın telekomünikasyon şirketini hackledi).

---

### Geleceğin Tehditleri
- Zero Trust mimarisi zorunlu hale geliyor
- Yapay zeka destekli saldırılar
- Siber savaş, askeri çatışmanın bir uzantısı olarak

---

<a name="hafta-3"></a>
## HAFTA 3 — Güvenlik Protokolleri ve Kimlik Doğrulama I

### Güvenlik Protokolü Nedir?

Bir güvenlik protokolü, **tarafların güvenli şekilde nasıl iletişim kuracağını** tanımlar. Kriptografi ile erişim kontrolünü birbirine bağlar. Kimlik doğrulama, ödeme sistemleri ve tüm ağ iletişiminde kullanılır.

**Protokoldeki Taraflar (Principals):**
- İnsanlar ve kurumlar
- Bilgisayarlar ve cihazlar
- Ağlar ve fiziksel iletişim kanalları

---

### Protokoller Neden Başarısız Olur?

**Yanlış tehdit modeli:** Yanlış saldırgan için tasarlamak. Her protokol varsayımlarını açıkça belirtmeli — bu varsayımlar ihlal edildiğinde protokol çöker.

**Yaygın başarısızlık kaynakları:**
- Zayıf algoritmalar
- Kısa anahtarlar
- Kötü anahtar yönetimi
- Protokol tasarım hataları (ör. replay saldırısı koruması olmaması)

**Doğru şifreyi kullanan ama replay zafiyeti olan bir protokol yine de kırılmıştır.**

---

### Klasik Saldırı Türleri

#### Gizlice Dinleme (Eavesdropping)
Saldırgan, iki taraf arasındaki iletişimi değiştirmeden yakalar. Temel savunma: trafiği şifrelemek.

#### Kimlik Avı (Phishing)
Saldırgan güvenilen bir tarafı (banka, yönetici) taklit ederek kullanıcıyı kimlik bilgilerini açıklamaya ikna eder. Savunma: kullanıcı eğitimi, güçlü kimlik doğrulama, anti-phishing filtreleri.

#### Tekrar Saldırısı (Replay Attack)
Saldırgan meşru bir mesajı kaydedip **daha sonra tekrar göndererek** sistemi kandırır. Örnek: garaj kapısı sinyalini kaydedip tekrar göndererek kapıyı açmak.

**Tekrar saldırısına karşı savunma:** **Nonce** (bir kez kullanılan sayı) veya **zaman damgası** kullanmak. Eski mesajlar reddedilir.

#### Kaba Kuvvet Saldırısı (Brute-Force)
Doğru kombinasyon bulunana kadar tüm olası kombinasyonlar denenir. Zayıf parola/anahtarlara karşı etkilidir. Uzun anahtarlar ve yavaş hash algoritmaları ile hafifletilir.

---

### Challenge-Response Kimlik Doğrulama

Dinamik kimlik doğrulamanın temel mekanizması:

1. **Kullanıcı → Sunucu:** "Giriş yapmak istiyorum"
2. **Sunucu → Kullanıcı:** "İşte rastgele bir challenge (nonce)"
3. **Kullanıcı → Sunucu:** "Cevabım = f(challenge, gizli_bilgim)"
4. **Sunucu** cevabı doğrular — parola asla iletilmez

**Temel özellik:** Her giriş farklı bir challenge kullanır → replay saldırısı işe yaramaz.

**Nonce (Number Used Once):** Her kimlik doğrulama girişimi için sunucu tarafından üretilen rastgele, benzersiz değer. *Tazelik* (freshness) garantisi sağlar.

---

### Araç İmmobilizer Sistemi

Challenge-response'un gerçek hayat uygulaması:
- Araç anahtarı bir RFID çipi içerir
- Aracın ECU'su rastgele bir challenge gönderir
- Anahtar kriptografik bir yanıt hesaplar
- Motor yalnızca yanıt doğruysa çalışır
- Saldırgan eski bir sinyali tekrar göndermiş olsa bile araç çalışmaz

---

### Anahtar Yönetiminin Önemi

Kriptografi, anahtar yönetimi kadar güçlüdür:
- **Entropi ve rastgelelik:** Anahtarlar gerçekten rastgele olmalıdır
- **Global anahtar riski:** Ana anahtar ele geçirilirse türetilen tüm anahtarlar tehlikeye girer
- **Anahtar çeşitlendirme (Key diversification):** Farklı oturumlar ve cihazlar için farklı anahtarlar

---

### Pasif Anahtarsız Giriş (Passive Keyless Entry) ve Relay Saldırısı

Modern "anahtarsız girişli" araçlar, anahtarın yakınlığını tespit etmek için radyo sinyalleri kullanır:

**Relay saldırısı nasıl çalışır:**
1. Saldırgan A park halindeki aracın yanında durur
2. Saldırgan B araç sahibinin evinin yanında durur (anahtar orada)
3. Radyo yükselteçleri aracılığıyla anahtarın sinyalini uzaktan iletirler
4. Araç anahtarın yakında olduğunu sanır → kilit açılır ve araç çalışır

**Savunma: Ultra Wideband (UWB)**
- Sinyalin **Uçuş Süresi'ni (Time-of-Flight)** nanosecond hassasiyetinde ölçer
- Gerçek fiziksel mesafeyi santimetre doğruluğuyla belirler
- Anahtar X metreden uzaktaysa sistem açılmayı reddeder

---

### İki Faktörlü Kimlik Doğrulama (2FA)

İki bağımsız kimlik kanıtı gerektirir:
- **Bildiğin bir şey** (parola)
- **Sahip olduğun bir şey** (fiziksel cihaz, telefon)

**OTP (Tek Kullanımlık Parola):** Bir uygulama tarafından üretilen (ya da SMS ile gönderilen), ~30 saniyede sona eren zaman tabanlı kod.

**2FA sınırlamaları:**
- SMS tabanlı 2FA, **SIM swap saldırısına** karşı savunmasızdır — saldırgan telekomünikasyon şirketini ikna ederek numarayı kendi SIM'ine aktarır
- Gerçek zamanlı kimlik avı: saldırgan OTP'yi sona ermeden önce gerçek zamanlı olarak iletir
- Fiziksel zorlama
- Tam güvenli değil — ama tek başına paroladan çok daha iyi

---

### HTTP Digest Authentication

Basic Auth'tan (parolayı düz metin gönderir) gelişmiş bir yöntem:
- **Hash tabanlı challenge-response** kullanır
- Sunucu challenge olarak bir nonce gönderir
- İstemci `hash(kullanıcıadı:parola:nonce)` hesaplayıp gönderir
- Parola asla düz metin olarak iletilmez
- HTTPS kullanılmazsa MITM'e karşı hâlâ savunmasızdır

---

<a name="hafta-4"></a>
## HAFTA 4 — İleri Kimlik Doğrulama: Saldırılar ve Savunmalar

### MIG Ortadaki Adam Saldırısı (Yansıma Saldırısı / Reflection Attack)

Her iki tarafın da kimliğini kanıtlamak zorunda olduğu **karşılıklı kimlik doğrulama** protokollerine karşı kullanılır:

**Saldırı akışı:**
- Saldırgan aynı anda iki bağlantı açar (biri gerçek sisteme, biri kurban olarak)
- Gerçek sistem saldırgana bir challenge N gönderince, saldırgan **aynı challenge'ı sisteme başka bir bağlantıdan iletir**
- Sistem (ikinci bağlantıda) doğru yanıtı hesaplayıp geri gönderir
- Saldırgan bu yanıtı yakalayıp birinci bağlantıda kullanır
- Sistem kandırılmıştır

**Matematiksel gösterim:**
```
F → B : N          (Saldırgan bankaya nonce gönderir)
B → F' : N         (Banka aynı nonce'u 2. oturumda geri gönderir)
F' → B : {N}_K     (Saldırgan bankanın kendi yanıtını iletir)
B → F : {N}_K      (Banka saldırganı doğrular)
```

**Yansıma saldırısına karşı savunmalar:**
- İmzalı mesaja **alıcının kimliğini** eklemek — sunucu kendi challenge'ını yanıt olarak kullanamaz
- **Yönlü anahtarlar** kullanmak (her yön için farklı anahtar)
- **Kimlik bağlamalı challenge-response**

---

### Relay Saldırısı ile Reflection Saldırısı Karşılaştırması

| Özellik | Relay Attack | Reflection Attack |
|---|---|---|
| Hedef | Radyo mesafesini uzatarak yakınlık algısını kandırmak | Sistemin kendi challenge'ını kendi yanıtına karşı kullanmak |
| Bağlam | Kablosuz/fiziksel sistemler (araçlar, erişim kartları) | Ağ kimlik doğrulama protokolleri |
| Savunma | Uçuş Süresi (UWB), mesafe sınırlama | Mesajlara kimlik bağlama |

---

### Tekrar Saldırısı (Özet)

Daha önce yakalanan geçerli bir mesaj yeniden iletilir. Relay'den farklıdır (relay gerçek zamanlı iletir):

**Savunma:** Nonce'lar, zaman damgaları, sıra numaraları — her mesajın "taze" olduğunu garantiler.

---

### MITM Saldırısı (Ortadaki Adam)

Saldırgan iki iletişim kuran taraf arasına girer:
- Tüm trafiği okuyabilir (gizlice dinleme)
- Mesajları iletimde değiştirebilir (manipülasyon)
- Her iki tarafı da aynı anda taklit edebilir

**Savunma:** Sertifika doğrulamalı **HTTPS** / TLS. Sertifika sunucunun kimliğini kanıtlar ve taklit edilmesini engeller.

---

### Hafta 4 Slaytlarından Sınav Soruları

Hoca slaytların sonuna örnek sorular koymuştu. İşte bunlar ve cevapları:

**S1:** Bir saldırgan iki sistem arasındaki iletişime girer ve mesajları iletir veya değiştirir. Bu saldırının adı nedir?
→ **C) Man-in-the-Middle saldırısı**

**S2:** Karşılıklı kimlik doğrulama protokolünde saldırgan şu işlemi yapar: F→B:N, B→F':N, F'→B:{N}K, B→F:{N}K. Hangi zafiyet kullanılmaktadır?
→ **A) Aynı anahtarın iki yönlü kullanılması**

**S3:** Hangisi reflection attack'ı önlemek için kullanılabilir?
→ **A) Mesaja taraf kimliği eklemek**

**S4:** Bir araç keyless entry sistemi kullanıyor. İki saldırgan: biri evin yanında, biri arabanın yanında. Sinyaller birbirine iletiliyor ve araba açılıyor. Bu saldırı türü hangisidir?
→ **B) Relay attack**

**S5:** Radar uçağa challenge gönderir. Düşman uçak bu challenge'ı başka bir dost uçağa iletir ve gelen cevabı radara gönderir. Bu saldırının temel özelliği nedir?
→ **C) Mesajlar iletilir**

**S6:** Bir araç üreticisi sistemi UWB ile güncelliyor ve Time-of-Flight ölçümü yapıyor. Temel güvenlik amacı nedir?
→ **B) Araç ile anahtar arasındaki gerçek mesafeyi hassas şekilde ölçmek**

**S7:** Radar 20 ms içinde doğru cevap alıyor. Bundan kesin olarak ne çıkarılabilir?
→ **B) Anahtara sahip cihazın belirli bir maksimum mesafe içinde olduğu**

---

<a name="hafta-5"></a>
## HAFTA 5 — Mesaj Manipülasyonu ve Gerçek Dünya Saldırıları

*(Not: Hafta 5 içeriği büyük ölçüde Hafta 8 ile örtüşür — tam işleme için Hafta 8'e bakın.)*

### Ön Ödemeli Sayaç Saldırısı

Ödeme/sayaç sistemlerinde replay saldırısı örneği:
- **ABAB tekrar deseni:** Saldırgan belirli bir sayaç artışı dizisini kaydedip tekrarlıyor
- **Durum yönetimi açığı:** Sistem, tekrarlanan mesajları meşru yeni komutlar olarak işliyor
- **Mantıksal zafiyet:** Sayaç tekrarlanan dizileri düzgün tespit edemiyor

**Ders:** Nonce'lar, monotonik artan sayaçlar, zaman damgaları ile replay koruması; durum değişikliği işleyen her sistem için kritiktir.

---

### Taksi Puls Saldırısı

- Taksiler mesafe/ücreti sensör pulse'larıyla ölçer
- Saldırgan sahte sensör sinyalleri enjekte ederek mesafe sayacını manipüle eder
- **Bütünlük ihlali** — ölçülen veri özgün değil

**Ders:** Sensör verisi okuyan her sistem, verinin kaynağını doğrulamak zorundadır.

---

### Takoğraf Manipülasyonu

- Kamyonlar hız ve sürüş saatlerini takoğrafla kaydeder
- Saldırgan pulse'ları silerek daha düşük hız kaydettiriyor → sürücü yönetmeliklere uyuyormuş gibi görünür
- **Bütünlük ihlali + düzenleyici dolandırıcılık**

---

### ATM Dolandırıcılığı

| Yöntem | Açıklama |
|---|---|
| Hat dinleme (Wiretapping) | ATM ile banka arasındaki hattı dinlemek |
| Manyetik şerit kopyalama | Kartın manyetik şeridinden veri okumak |
| PIN yakalama | Sahte tuş takımı veya kamera ile PIN kaydetmek |
| İç tehdit | Anahtar veya süreçlere erişimi olan banka çalışanı |

**Bu neden hâlâ sorun?** Kartlara çip (EMV) eklense bile birçok banka geriye dönük uyumluluk için manyetik şeridi korudu → saldırganlar bu zayıf yolu istismar etti.

**Chip & PIN'in hâlâ açıkları var:**
- Sızdırılan şerit verisiyle kart klonlama
- Uluslararası kullanım — bazı ülkeler çip desteklemez → manyetik şerit yedeği kullanılır
- Kamera ile omuz üzerinden PIN görüntüleme

---

# BÖLÜM B — VİZE SONRASI KONULAR (AĞIR AĞIRLIK)

---

<a name="hafta-8"></a>
## HAFTA 8 — Mesaj Manipülasyonu, Anahtar Yönetimi ve Protokoller

### MITM ile Mesaj Manipülasyonu

| Kavram | Açıklama |
|---|---|
| **Kimlik Taklidi (Impersonation)** | Saldırgan meşru bir taraf gibi davranır |
| **Mesaj Manipülasyonu** | Saldırgan iletim sırasında mesaj içeriğini değiştirir |
| **Bütünlük (Integrity)** | Verinin değiştirilmediğini garantileme |
| **Kimlik Doğrulama (Authentication)** | Konuştuğunuz kişinin iddia ettiği kişi olduğunu doğrulama |

Bu sorunlar birbiriyle bağlantılıdır: uygun kimlik doğrulama ve bütünlük kontrolleri olmadan, trafiği kesebilen her rakip taklit edebilir ya da manipüle edebilir.

---

### Uydu Sistemleri — Intelsat Örneği

Uydu komuta sistemleri bile manipülasyon riskiyle karşı karşıyadır:
- Uyduya gönderilen komutlar yakalanıp tekrarlanabilir
- **Savunma: Komut Doğrulama (Command Authentication)** — her komut kriptografik olarak imzalanmalıdır
- **Savunma: Replay Koruması** — zaman damgaları veya sıra numaraları eski komutların yeniden çalıştırılmasını engeller

---

### Sistem Sertleştirme (Hardening)

Sistemi saldırılara dayanıklı hale getirmek:
- **Replay koruması** — zaman damgaları, nonce'lar
- **Kimlik doğrulama** — herhangi bir komutu işlemeden önce kimliği doğrula
- **Bütünlük kontrolleri** — tüm mesajlarda hash veya MAC
- **Yetkilendirme** — doğrulanmış tarafın aynı zamanda izni olması gerekir
- **Fail-safe tasarım** — sistem bir hata/saldırı tespit ederse güvenli moda geçer (komutu çalıştırmak yerine reddeder)

---

### Ortam Değişimi ve Protokol Başarısızlığı

**Ross Anderson'ın kitabından temel ders:** Güvenlik protokolleri ortam hakkında belirli varsayımlar altında tasarlanır. Ortam değiştiğinde bu varsayımlar geçersiz kalabilir → protokol çöker.

Varsayım ihlali örnekleri:
- Protokol ağın özel olduğunu varsayıyor, ama internet'e bağlanıyor
- Protokol yalnızca belirli bir cihazın erişebileceğini varsayıyor, ama saldırganlar farklı cihazlar kullanıyor
- Güvenli olan şifreleme algoritması, daha yeni donanımla kırılabilir hale geliyor

**Ders:** Güvenlik modelleri, işletim ortamı önemli ölçüde değiştiğinde yeniden gözden geçirilmelidir.

---

### Seçilen Protokol Saldırısı (Chosen Protocol Attack)

Saldırgan şundan yararlanır:
1. Bir kriptografik anahtar birden fazla protokolde kullanılmaktadır
2. Protokollerden biri diğerinden zayıftır
3. Saldırgan zayıf protokolle etkileşime geçer → güçlü olanı saldırmak için bilgi elde eder

**Savunma:** Anahtarlar **uygulama bazında izole edilmelidir** — farklı protokoller veya sistemlerde asla anahtar yeniden kullanılmamalıdır. Buna **anahtar izolasyonu** denir.

---

### Mafia Ortadaki Adam Saldırısı (Mafia-in-the-Middle)

Challenge-response sistemlerine özgü gelişmiş bir MITM varyantı:

**Senaryo (Ross Anderson Şekil 4.3):**
- Kullanıcı bir satıcıyla işlem imzalıyor (ör. "10 altın al")
- Kullanıcı küçük bir alışveriş yaptığını sanıyor
- Kötü niyetli bir taraf aynı anda kullanıcının imzasını büyük yetkisiz bir banka işlemi için iletiyor
- Kullanıcı tamamen farklı bir şeyi yetkilendirmiş oluyor

**Savunma:** İmzalanan içeriğin kullanıcıya açıkça gösterilmesi ve onaylanması gerekir.

---

### Anahtar Yeniden Kullanımı

Kriptografideki en tehlikeli uygulamalardan biri:
- Aynı kriptografik anahtarı birden fazla sistem, uygulama veya amaç için kullanmak
- Anahtar bir sistemde ele geçirilirse → **tüm sistemler tehlikeye girer**
- Bir protokol savunmasızsa → **anahtar güçlü protokole sızar**

**Savunma:** Her amaç için ayrı, izole anahtarlar kullanmak.

---

### SMS 2FA Zafiyeti — SIM Swap Saldırısı

**SIM swap nasıl çalışır:**
1. Saldırgan kurbanın mobil operatörünü arar
2. Sosyal mühendislikle (kamuya açık kişisel bilgiler) operatörü kurbanın numarasını yeni bir SIM'e aktarmaya ikna eder
3. Artık saldırgan tüm SMS mesajlarını alıyor — OTP kodları dahil
4. **Kimlik hırsızlığı** tamamlanmış olur

**Savunma:** SMS yerine doğrulama uygulaması (TOTP) kullanmak. Yüksek değerli hesaplar için SMS'i ikinci faktör olarak kullanmamak.

---

### TOFU — İlk Kullanımda Güven / Yavru Ördek

**TOFU ilkesi:** Bir cihaz başka bir cihaza ilk kez bağlandığında, sunulan kimliğe güvenir ve gelecekteki bağlantılar için bunu hatırlar.

**Benzetme (Yavru Ördek):** Yumurtadan çıkan yavru ördek ilk gördüğü varlığa anne gibi davranır — bu bir insan bile olsa.

**Uygulama:** IoT cihaz eşleştirme. Cihaz, onu ilk yapılandıranı "benimser".

**Risk:** Bir saldırgan meşru sahibinden önce bağlanırsa, cihaz saldırgana güvenir.

**Savunma:** Donanım sıfırlama tüm güven kayıtlarını siler. Katı eşleştirme prosedürleri (fiziksel düğme basımı vb.).

---

### Anahtar Yönetimi

Sorun: İki taraf güvenilmez bir ağ üzerinden nasıl paylaşılan bir gizli anahtar oluşturur?

**Dört yaklaşım:**

| Yöntem | Nasıl | Güven Modeli |
|---|---|---|
| **1. Simetrik Anahtar Dağıtımı** | Her iki taraf da önceden paylaşılmış gizli bir anahtara sahiptir | Önceden güvenli kanal gerektirir |
| **2. Asimetrik (Public Key)** | Taraf A public key paylaşır; B bununla şifreler; yalnızca A'nın private key'i çözer | Matematiksel güven |
| **3. Diffie-Hellman** | Her iki taraf da asla göndermeden aynı paylaşılan sırrı bağımsız olarak hesaplar | Matematiksel güvenlik (anahtar gönderilmez) |
| **4. PKI (Açık Anahtar Altyapısı)** | Sertifika Otoriteleri (CA) açık anahtar sahipliğini garantiler | Kurumsal güven |

**Güven Modelleri:**
- **PKI / Merkezi Güven:** Güvenilir bir CA kimliği garanti eder
- **TOFU:** İlk bağlantıya güven; sürekliliği doğrula
- **Zero Trust:** Varsayılan olarak hiçbir şeye güvenme; her erişimi her seferinde doğrula

---

### Anahtar Dağıtımı — Güvenilir Üçüncü Taraf (TTP)

A ve B paylaşılan bir anahtarı olmaksızın güvenli iletişim kurmak istediğinde:
1. Hem A hem B, bir **Güvenilir Üçüncü Taraf (TTP)** sunucusuyla ön paylaşımlı anahtarlara sahiptir
2. A, TTP'ye sorar: "B ile konuşmak istiyorum"
3. TTP bir **oturum anahtarı K_AB** üretir ve her birine kendi anahtarıyla şifrelenmiş olarak gönderir
4. A ve B artık K_AB'yi paylaşır ve güvenli iletişim kurabilir

---

### Needham-Schroeder Protokolü

Güvenilir bir sunucu (S) kullanan klasik anahtar dağıtım protokolü:

```
Mesaj 1: A → S : A, B, NA                     (A oturum anahtarı ister, nonce ekler)
Mesaj 2: S → A : {NA, B, KAB, {KAB, A}KB}KA   (S oturum anahtarını şifreli gönderir)
Mesaj 3: A → B : {KAB, A}KB                   (A, B'nin kısmını iletir)
Mesaj 4: B → A : {NB}KAB                      (B onaylar, kendi nonce'unu gönderir)
Mesaj 5: A → B : {NB-1}KAB                    (A şifresi çözebildiğini kanıtlar)
```

**Amaç:** Güvenilir bir sunucu aracılığıyla A ile B arasında paylaşılan bir oturum anahtarı oluşturmak.

**Zafiyet:** Orijinal protokol **replay saldırısına** karşı savunmasız bulundu — eski bir oturum anahtarı ele geçirilirse saldırgan 3-5 arası mesajları tekrarlayarak A gibi davranabilir.

**Düzeltme (Kerberos):** Replay'i önlemek için tüm mesajlara zaman damgası eklendi.

---

### Kerberos Protokolü

Yaygın olarak kullanılan anahtar dağıtım protokolü (Windows Active Directory'de kullanılır):

```
(1) KRB_AS_REQ:   İstemci → KDC: "Giriş yapmak istiyorum"
(2) KRB_AS_REP:   KDC → İstemci: Bilet Verme Bileti (TGT) + oturum anahtarı
(3) KRB_TGS_REQ:  İstemci → KDC: "B Hizmetine erişmek istiyorum" (TGT sunar)
(4) KRB_TGS_REP:  KDC → İstemci: B için Servis Bileti + oturum anahtarı
(5) KRB_AP_REQ:   İstemci → B Sunucusu: Servis Bileti
(6) KRB_AP_REP:   B Sunucusu → İstemci: Karşılıklı kimlik doğrulama onayı
```

**Temel kavramlar:**
- **KDC (Key Distribution Center):** Güvenilir üçüncü taraf
- **TGT (Ticket Granting Ticket):** Kimlik bilgilerini yeniden girmeden servis bileti almanızı sağlar
- **Zaman damgaları:** Replay saldırısını önler
- **Nonce'lar:** Tazeliği garantiler

---

<a name="hafta-10"></a>
## HAFTA 10 — Kriptografinin Temelleri

### Kriptografi Nedir?

Kriptografi, **rakipler varlığında güvenli iletişim** bilimidir. Matematik ile güvenliğin kesişiminde yer alır.

**Kriptografinin üç hedefi:**
1. **Gizlilik (Confidentiality)** — Yalnızca amaçlanan alıcı mesajı okuyabilir
2. **Bütünlük (Integrity)** — Mesaj iletimde değiştirilmemiştir
3. **Kimlik Doğrulama (Authentication)** — Gönderen iddia ettiği kişidir

**Temel terminoloji:**
| Terim | Anlamı |
|---|---|
| Plaintext | Orijinal, okunabilir mesaj |
| Ciphertext | Şifrelenmiş, okunamaz mesaj |
| Şifreleme (Encryption) | Plaintext → Ciphertext dönüşümü |
| Şifre Çözme (Decryption) | Ciphertext → Plaintext dönüşümü |
| Anahtar (Key) | Şifreleme/çözme için kullanılan sır |

---

### Üç Güvenlik Modeli

**1. Mükemmel Güvenlik (Perfect Security)**
- Teorik olarak kırılamaz
- Örnek: **One-Time Pad**
- Pratikte uygulanması zordur

**2. Somut Güvenlik (Concrete Security)**
- Gerçek dünyanın hesaplama limitlerini esas alır (zaman, bellek, işlemci)
- "Güvenli" demek: kırmak evrenin yaşından daha uzun sürer
- Örnek: **AES-128'in** 2¹²⁸ olası anahtarı var → brute force ~10²⁶ yıl alır

**3. Anlamsal Güvenlik (Semantic Security)**
- Hiçbir ciphertext, plaintext hakkında bilgi sızdırmaz
- **Deterministik şifreleme bunu karşılamaz** — aynı plaintext her zaman aynı ciphertext üretir → saldırgan desenleri fark eder
- **Rastgele şifreleme** karşılar — aynı plaintext her seferinde farklı ciphertext üretir

---

### Kriptografinin Yapı Taşları

| Yapı Taşı | Açıklama | Örnekler |
|---|---|---|
| Akış Şifresi (Stream Cipher) | Veriyi bit bit şifreler, keystream kullanır | RC4, ChaCha20 |
| Blok Şifresi (Block Cipher) | Sabit boyutlu blokları şifreler | AES, DES |
| Hash Fonksiyonu | Tek yönlü dönüşüm, sabit uzunlukta çıktı | SHA-256, MD5 |
| Asimetrik Kriptografi | Public/private anahtar çiftleri | RSA, ECC |

---

### Simetrik ile Asimetrik Kriptografi Karşılaştırması

| Özellik | Simetrik | Asimetrik |
|---|---|---|
| Anahtarlar | Tek paylaşılan gizli anahtar | Public anahtar + Private anahtar |
| Hız | Çok hızlı | Çok daha yavaş |
| Anahtar dağıtımı | Sorun (güvenli kanal gerektirir) | Kolay (public anahtar herkese açık) |
| Kullanım alanları | Toplu şifreleme (AES) | Anahtar değişimi, dijital imza |
| Örnekler | AES, DES, 3DES | RSA, ECC, Diffie-Hellman |

**Dijital İmza:**
- Gönderen mesajın hash'ini **private key** ile şifreler
- **Public key** sahibi olan herkes imzayı doğrulayabilir
- Mesajın gönderenden geldiğini ve değiştirilmediğini kanıtlar
- Hem **kimlik doğrulama** hem de **bütünlük** sağlar

---

### Akış Şifresi

Veriyi **bit/byte bazında** pseudorandom bir keystream kullanarak şifreler:

```
Ciphertext = Plaintext ⊕ Keystream
```

**Kritik kural: Keystream asla yeniden kullanılmamalıdır.** Aynı keystream iki mesaj için kullanılırsa:
```
C1 = P1 ⊕ KS
C2 = P2 ⊕ KS
C1 ⊕ C2 = P1 ⊕ P2   ← Saldırgan her iki plaintext'in XOR'unu elde eder → ikisi de kurtarılabilir
```

**Kullanım alanları:** TLS, HTTPS, VPN, kablosuz iletişim

---

### Blok Şifresi

Veriyi bir anahtar kullanarak **sabit boyutlu bloklarda** şifreler:
```
C = E_K(M)   burada M bir plaintext bloğu, K anahtardır
```

**Örnekler:** AES (128-bit blok), DES (64-bit blok, artık kullanılmıyor)

---

### Kriptanaliz

Şifreleri kıran bilim:
- **Doğrusal kriptanaliz (Linear cryptanalysis):** Şifrenin doğrusal olmayan işlemlerine yaklaşımlar bulur
- **Diferansiyel kriptanaliz (Differential cryptanalysis):** Giriş farklılıklarının şifreleme turlarında nasıl yayıldığını analiz eder

**SP Ağları (Substitution-Permutation Networks):**
AES tarzı şifreler, doğrusal ve diferansiyel kriptanalizi son derece zorlaştırmak için dönüşümlü ikame (S-box) ve permütasyon katmanları kullanır.

**Feistel Ağları:**
DES tarzı şifreler bloğu ikiye bölerek dönüşümlü işler. AES bunun yerine SP ağları kullanır.

---

### Rastgele Oracle Modeli

Mükemmel bir hash fonksiyonu gibi davranan teorik bir model:
- Bir girdi geldiğinde tamamen rastgele bir çıktı üretir ve bunu hatırlar (aynı girdi → aynı çıktı, ama tamamen öngörülemez)
- Gerçek hash fonksiyonları buna yaklaşmaya çalışır

---

<a name="klasik"></a>
## KLASİK ŞİFRELER (Kriptografi Sunum)

### Caesar Şifrelemesi

En basit yerine koyma şifresi:
- Her harfi sabit bir miktar kaydır (ör. +3)
- A→D, B→E, vb.
- **Önemsizce kırılır** — yalnızca 25 olası kaydırma vardır

---

### Vigenère Şifrelemesi

Fransız diplomat Blaise de Vigenère tarafından geliştirilen, Caesar'dan üstün bir yöntem:

**Nasıl çalışır:**
- Bir anahtar kelime seçin (ör. "RUN")
- Harflere sayı atayın: A=0, B=1, ..., Z=25
- Şifreleme formülü: Her harf için **C = (P + K) mod 26**, anahtarı döngüsel kullanın

**Örnek:**
```
Düz metin:    T  O  B  E  O  R  N  O  T  T  O  B  E  T  H  A  T  I  S  T  H  E  Q  U  E  S  T  I  O  N
Anahtar:      R  U  N  R  U  N  R  U  N  R  U  N  R  U  N  R  U  N  R  U  N  R  U  N  R  U  N  R  U  N
Şifreli:      K  I  O  V  I  E  E  I  G  K  I  O  V  N  U  R  N  V  J  N  U  V  K  H  V  M  G  Z  I  A
```

**Kırma (Kasiski Yöntemi):** Friedrich Kasiski (19. yüzyıl), şifreli metindeki tekrarlayan kalıpların **anahtar uzunluğunu** ele verdiğini gösterdi — ardından her pozisyon basit bir Caesar şifresi olarak saldırıya uğrar.

---

### One-Time Pad (OTP)

**Teorik olarak mükemmel güvenli olan tek şifre:**

Gereksinimler:
1. Anahtar **mesajla tam aynı uzunluğa** sahip olmalıdır
2. Anahtar **gerçek anlamda rastgele** olmalıdır
3. Anahtar **yalnızca bir kez kullanılmalıdır**

**Mükemmel gizlilik:** Bir saldırgan ciphertext'e bakarak "Heil Hitler" mi yoksa "Hang Hitler" mi olduğunu belirleyemez — her ikisi de farklı anahtarlarla eşit olasılıklı yorumlardır. Buna **sıfır bilgi sızıntısı** denir.

**OTP'nin pratik sorunları:**
- Anahtar dağıtımı son derece zordur (tüm gelecekteki mesajlar kadar uzun bir anahtarı güvenli paylaşmak gerekir)
- **Bütünlük koruması yoktur** — saldırgan ciphertext'te bit çevirebilir ve plaintext öngörülebilir biçimde değişir (ama okuyamaz)
- Anahtar yeniden kullanımı güvenliği tamamen yok eder

---

### Playfair Şifrelemesi

1854'te Charles Wheatstone tarafından geliştirilmiş, Baron Playfair tarafından tanıtılmıştır:
- **İlk modern blok şifre** (çiftler halinde, yani iki harf birden şifreler)
- 5×5'lik bir matris kullanır (J harfi çıkarılır)
- Matrise önce anahtar yazılır, ardından kalan harfler sırayla eklenir

**"PALME" anahtarıyla örnek matris:**
```
P A L M E
R S T O N
B C D F G
H I K Q U
V W X Y Z
```

**Şifreleme kuralları:**
- Harfler aynı satırdaysa → sağa kaydır
- Harfler aynı sütundaysa → aşağı kaydır
- Aksi takdirde → oluşturdukları dikdörtgenin köşelerini al

Bu yöntem, harf çiftlerini şifrelediğinden Caesar'a göre kırmak çok daha zordu.

---

<a name="hafta-11"></a>
## HAFTA 11 — AES Güvenliği ve Çalışma Modları

### AES'e Genel Bakış (Advanced Encryption Standard)

AES, dünyada en yaygın kullanılan simetrik blok şifredir. DES'in yerini almak üzere 2001'de standartlaştırıldı.

**Parametreler:**
| Parametre | Değer |
|---|---|
| Blok boyutu | Her zaman **128 bit (16 byte)** |
| Anahtar boyutları | 128-bit, 192-bit veya **256-bit** |
| Tur sayısı | 10, 12 veya 14 (anahtar boyutuna göre) |

---

### Anahtar Uzunluğu ve Brute Force

**AES-128:**
- 2¹²⁸ olası anahtar
- Saniyede 10¹² deneme yapan bir süper bilgisayar **2¹²⁸ / 10¹² ≈ 10²⁶ yıl** alır
- Brute force hesaplama açısından imkânsızdır

**AES-256:** Çok daha güçlü (2²⁵⁶ anahtar) — kuantum sonrası güvenlik planlaması için tercih edilen.

**Temel çıkarım:** AES'in kendisi zayıf nokta değildir. Zayıflık **nasıl kullanıldığından** kaynaklanır (mod seçimi, anahtar yönetimi, nonce yeniden kullanımı).

---

### Blok Boyutu ile Mesaj Boyutu

AES tam olarak **16 byte'ı** bir seferde şifreler.

Bir mesaj 40 byte'sa:
```
Blok 1: 16 byte → şifrelendi
Blok 2: 16 byte → şifrelendi
Blok 3:  8 byte → 16 byte'a ulaşmak için dolgu (padding) gerekli
```

**Dolgu (Padding):** Son bloğu 16 byte'a tamamlar. Padding'in yanlış işlenmesi büyük zafiyetlere yol açar.

---

### AES Çalışma Modları

AES bir blok şifresidir — yalnızca tek bir 16 byte bloğu nasıl şifreleyeceğini bilir. **Çalışma modları** birden fazla bloğun nasıl işleneceğini tanımlar.

---

#### ECB — Elektronik Kod Kitabı Modu ❌ (Güvensiz)

**Formül:** `C_i = E_K(P_i)` — her blok bağımsız olarak aynı anahtarla şifrelenir.

**Ölümcül açık:** Aynı plaintext bloğu her zaman aynı ciphertext bloğunu üretir.

**Penguen Sorunu:** Bir penguenin görüntüsünü ECB moduyla şifrelerseniz, çıktı hâlâ penguenin ana hatlarını gösterir — özdeş piksel blokları özdeş şifreli bloklara dönüşür. **Desen şifrelemenin içinden sızar.**

**Kural:** ECB gerçek veri için ASLA kullanılmamalıdır.

---

#### CBC — Şifre Blok Zincirleme Modu ✅ (Daha İyi)

**Formül:**
```
C_1 = E_K(P_1 ⊕ IV)          ← İlk blok Başlangıç Vektörü (IV) kullanır
C_i = E_K(P_i ⊕ C_{i-1})    ← Her blok bir önceki ciphertext bloğuyla XOR'lanır
```

**ECB'nin sorununu nasıl çözer:**
- Aynı plaintext bloğu her seferinde **farklı** ciphertext üretir (önceki ciphertext bloğu karıştırıldığı için)
- İlk blok için rastgele bir **IV (Başlangıç Vektörü)** gerektirir

**Dezavantajlar:**
- Şifreleme **sıralı** olmalıdır — paralelleştirilemez (her blok öncekine bağlıdır)
- Blok boyutuna hizalanmayan mesajlar için **padding** gerektirir
- **Padding Oracle Saldırısı:** Sistem padding'in geçerli olup olmadığını açıklarsa, saldırgan bu sinyali anahtar bilmeksizin ciphertext'i byte byte çözebilir

---

#### CTR — Sayaç Modu ✅✅ (Çoğu kullanım için en iyi)

**Temel kavram:** CTR modu, AES'i bir **akış şifresi** gibi kullanır.

**Bileşenler:**
- **Nonce (N):** Bu mesaj için seçilen benzersiz değer. Mesaj boyunca sabit kalır.
- **Sayaç (i):** 0'dan başlar, her blokta 1 artar.
- **Keystream bloğu:** `KS_i = AES_K(N || i)`

**Şifreleme/Şifre Çözme:**
```
C_i = P_i ⊕ KS_i
P_i = C_i ⊕ KS_i    ← Şifre çözme aynıdır! Ayrı "decipher" işlemi gerekmez
```

**CTR'nin avantajları:**
- ✅ **Paralelleştirilebilir** — her bloğun keystream'i bağımsız hesaplanabilir
- ✅ **Padding gerektirmez** — akış şifresi herhangi bir uzunluğu işler
- ✅ **Şifreleme ve şifre çözme aynı işlemdir**

**CTR modu keystream üretimi:**
```
KS_0 = AES_K(N||0)    → P_0 ile XOR → C_0
KS_1 = AES_K(N||1)    → P_1 ile XOR → C_1
KS_2 = AES_K(N||2)    → P_2 ile XOR → C_2
...
```

---

### ⚠️ Nonce Yeniden Kullanım Felaketi

Bu dersin en kritik kavramlarından biridir:

**Aynı (Anahtar, Nonce) çiftini iki farklı mesaj için kullanırsanız ne olur?**

```
C1 = P1 ⊕ KS       (1. mesaj KS keystream ile şifrelendi)
C2 = P2 ⊕ KS       (2. mesaj AYNI keystream ile şifrelendi)

Saldırgan her iki ciphertext'i yakalar:
C1 ⊕ C2 = (P1 ⊕ KS) ⊕ (P2 ⊕ KS) = P1 ⊕ P2
```

**Saldırgan P1 ⊕ P2'yi elde eder — her iki plaintext'in XOR'u.** Bilinen plaintext teknikleri veya istatistiksel analiz ile her iki mesaj da tam olarak kurtarılabilir.

**Kural: (Anahtar, Nonce) çifti ASLA yeniden kullanılmamalıdır.**

---

#### GCM — Galois/Sayaç Modu ✅✅✅ (Kimlik doğrulamalı şifreleme için en iyi)

GCM = CTR modu + **kimlik doğrulama etiketi (authentication tag)**

- **Gizlilik** (CTR gibi) VE **bütünlük/kimlik doğrulama** sağlar
- Kimlik doğrulama etiketi, ciphertext'te herhangi bir kurcalamayı tespit eder
- TLS 1.3, HTTPS, SSH, WireGuard VPN'de kullanılır

**Modern uygulamaların büyük çoğunluğu için önerilen moddur.**

---

### Özet Tablo: AES Modları

| Mod | Desen Sızar mı? | Paralelleştirilebilir? | Padding? | Bütünlük? | Kullanım? |
|---|---|---|---|---|---|
| **ECB** | Evet ❌ | Evet | Evet | Hayır | Asla |
| **CBC** | Hayır ✅ | Şifreleme: Hayır, Çözme: Evet | Evet | Hayır | Eski sistemler |
| **CTR** | Hayır ✅ | Evet ✅ | Hayır ✅ | Hayır | İyi |
| **GCM** | Hayır ✅ | Evet ✅ | Hayır ✅ | Evet ✅ | En iyi |

---

<a name="hash"></a>
## HASH FONKSİYONLARI

### Hash Fonksiyonu Nedir?

Hash fonksiyonu şu özelliklere sahip matematiksel bir yapıdır:
- **Herhangi uzunluktaki girdi** alır (dosya, parola, belge)
- **Sabit uzunlukta çıktı** üretir (hash veya özet)
- Dönüşüm **deterministiktir:** aynı girdi → her zaman aynı çıktı
- Dönüşüm **tek yönlüdür:** çıktı verildiğinde girdiyi bulmak pratikte hesaplama açısından imkânsızdır

```
H("ali123") = f0bd251b08338c230d420f33106faf13a12cace5c5b0b9b5fbd7be3c7eca6e62
```

Çıktı tamamen rastgele görünür ve girdiyle hiçbir benzerlik taşımaz.

---

### Hash Fonksiyonlarının Üç Güvenlik Özelliği

| Özellik | Açıklama | Saldırı Adı |
|---|---|---|
| **Ön Görüntü Direnci (Preimage Resistance)** | H değeri verildiğinde, H(x) = H olacak herhangi bir x bulunamaz | Ön görüntü saldırısı |
| **İkinci Ön Görüntü Direnci (Second Preimage Resistance)** | A girdisi verildiğinde, H(A) = H(B) olacak farklı bir B bulunamaz | İkinci ön görüntü saldırısı |
| **Çakışma Direnci (Collision Resistance)** | H(A) = H(B) olacak herhangi iki girdi bulunamaz | Çakışma saldırısı |

**Önemli ayrım:**
- **Çakışma direnci** (herhangi iki eşleşen girdi bul), ikinci ön görüntü direncinden daha zor sağlanır
- Tüm hash fonksiyonlarının çakışması vardır (sonsuz girdi → sonlu çıktı) — sadece *bulmak* hesaplama açısından imkânsız olmalıdır
- **Çakışmalar matematiksel olarak kesinlikle vardır** — ama pratikte bulmak imkânsız olmalıdır

---

### SHA-256

- Çıktı: **256 bit** (32 byte)
- Şu anda güvenli — bilinen pratik çakışma saldırısı yoktur
- Güvenlik yalnızca çıktı boyutundan değil **iç yapıdan** kaynaklanır (karmaşık karıştırma turları, doğrusal olmayan işlemler)
- Kullanım alanları: Bitcoin, TLS, kod imzalama, parola hash'leme (salt ile)

**SHA-1 ve MD5 kırılmıştır:**
- MD5'in iç yapısı (sıkıştırma + turlar + doğrusal işlemler) bitleri yeterince karıştırmaz → çakışmalar bulunmuştur
- SHA-1 de ele geçirilmiştir
- **Güvenlik açısından kritik uygulamalarda asla MD5 veya SHA-1 kullanmayın**

---

### Çığ Etkisi (Avalanche Effect)

Kritik bir özellik: **girdideki küçük bir değişiklik çıktıda büyük ve tamamen öngörülemeyen bir değişikliğe yol açar.**

```
H("ali123") = f0bd251b...
H("ali124") = 9f3c842a...   ← Tamamen farklı!
```

Bu şu anlama gelir:
- Saldırgan istenen bir hash'e ulaşmak için küçük ayarlamalar yapamaz
- Benzer girdilerle hash'leri arasında herhangi bir korelasyon yoktur
- Hash fonksiyonlarını bütünlük kontrolü için kullanışlı kılan budur

---

### Hash Fonksiyonlarıyla Parola Saklama

**Yanlış yol:** Parolaları düz metin saklama — veritabanı çalınırsa tüm parolalar ifşa olur.

**Doğru yol:** Yalnızca `H(parola)` sakla — veritabanı çalınsa bile saldırgan yalnızca hash'lere sahip olur.

**Doğrulama:** Kullanıcı `girdi` ile giriş yaparken `H(girdi)` hesaplanır ve saklanan `H(parola)` ile karşılaştırılır.

---

### Salt — Kritik Savunma

**Düz hash'lemenin sorunu:** Aynı parolaya sahip iki kullanıcı aynı hash değerine sahip olur. Veritabanına sahip saldırgan yaygın parolaları anında tespit edebilir.

**Salt:** Her parolaya hash'lemeden önce eklenen rastgele bir değer:

```
Saklanan: (salt, H(parola + salt))

Parolası "sifre" olan Kullanıcı 1: salt = "Aew1%..." → saklanan hash = "AxRJ!#..."
Parolası "sifre" olan Kullanıcı 2: salt = "KD21#..." → saklanan hash = "HyrE+'..."
```

Aynı parola → tamamen farklı hash'ler!

**Avantajlar:**
- Özdeş parolalar farklı hash üretir → desen tespiti imkânsız
- Sözlük saldırısı verimliliğini ortadan kaldırır — her parola ayrı ayrı saldırıya uğratılmalıdır
- Hash değeriyle birlikte saklanır (gizli olması gerekmez)

---

### Rainbow Table Saldırıları

**Rainbow table:** Yaygın parolaları hash değerlerine eşleyen önceden hesaplanmış tablo.

Saldırı: Saldırgan milyonlarca yaygın parolanın hash'ini çevrim dışı hesaplar. Çalınan bir veritabanı aldığında sadece **arama yapar**.

**Salt rainbow table'ı neden etkisiz kılar:**
- Saldırganın her parola için her olası salt ile hash hesaplaması gerekir
- Bu, gereken depolama alanını ve hesaplamayı muazzam ölçüde artırır → pratikte imkânsız

---

### Pepper

**Pepper** salt'a benzer ama:
- **Uygulamada** saklanır (veritabanında değil)
- **Gizlidir** — veritabanı uygulama kodu olmadan çalınırsa pepper bilinmez
- Saldırganın hash ve salt'a sahip olsa bile pepper olmadan parolayı kıraması imkânsızdır

**Birleşik savunma:** hash + salt + pepper = çok güçlü

---

### Parola Saldırısı Türleri

| Saldırı | Açıklama | Savunma |
|---|---|---|
| **Sözlük Saldırısı (Dictionary)** | Bir listeden yaygın parolalar denenir | Güçlü parola politikası |
| **Brute Force** | Tüm kombinasyonlar denenir | Uzun parolalar; yavaş hash algoritmaları |
| **Rainbow Table** | Önceden hesaplanmış hash arama | Salt |
| **Second Preimage** | Aynı hash'e sahip farklı girdi bulma | Güçlü hash algoritması (SHA-256+) |

---

### Yavaş Hash Algoritmaları

**Neden yavaş?** Brute force ve sözlük saldırılarını ekonomik olarak imkânsız kılmak için.

**Normal hash (SHA-256):** Saldırgan GPU ile saniyede milyarlarca hash hesaplayabilir.

**Yavaş hash:** Kasıtlı olarak hash başına önemli hesaplama gerektirecek şekilde tasarlanmıştır → saldırgan saniyede yalnızca binlerce deneme yapabilir.

| Algoritma | Özel Özellik |
|---|---|
| **bcrypt** | Ayarlanabilir zaman maliyeti; otomatik salt içerir; parolalar için tasarlandı |
| **Argon2** | Modern standart; ayarlanabilir zaman VE bellek maliyeti; bellek bağımlı (GPU saldırılarına dirençli) |

**Argon2**, Parola Hash Yarışması'nın galibidir ve parola saklama için güncel önerilen standarttır.

**Maliyet parametreleri:**
- **Zaman maliyeti:** Hesaplama iterasyon sayısı (daha fazla = daha yavaş = saldırmak daha zor)
- **Bellek maliyeti:** Gereken RAM miktarı (GPU saldırıları başarısız olur çünkü GPU'ların çekirdek başına sınırlı RAM'i vardır)

---

### Güçlü Parola Politikası

- Uzun, tahmin edilmesi zor parolalar kullanın
- Parola yöneticisi kullanın
- Siteler arasında parolaları asla yeniden kullanmayın

**Savunma özeti:** Düzgün güvenli bir sistem **hash + salt + pepper + yavaş algoritma (bcrypt/Argon2) + güçlü parola politikası** kullanır — tüm bilinen saldırıları pratikte imkânsız kılar.

---

<a name="sqli"></a>
## SQL INJECTION — app2.py ve app3.py

### SQL Injection Nedir?

SQL Injection, saldırganın veritabanı tarafından çalıştırılan bir girdi alanına kötü amaçlı SQL kodu enjekte ettiği bir kod enjeksiyon saldırısıdır.

**En yaygın ve tehlikeli web güvenlik açıklarından biridir.**

---

### Savunmasız Pattern (app2.py'den)

```python
# HATALI (SAVUNMASIZ) KULLANIM:
query = f"SELECT * FROM users WHERE username = '{username}' AND password = '{password}'"
cur.execute(query)
```

**Saldırgan şunu girerse:**
```
kullanıcıadı: admin' OR '1'='1
parola: herhangi bir şey
```

**Oluşan sorgu:**
```sql
SELECT * FROM users WHERE username = 'admin' OR '1'='1' AND password = 'herhangi bir şey'
```

`'1'='1'` her zaman doğru olduğundan WHERE koşulu TÜM kullanıcıları döndürür — saldırgan **parolayı bilmeden** admin olarak giriş yapar.

---

### UNION Tabanlı SQL Injection (app3.py'den)

**app3.py'deki lab payload'u:**
```sql
' UNION SELECT 1, name, 'metadata' FROM sqlite_master WHERE type='table' --
```

Bu payload:
1. Orijinal sorgunun string'ini kapatır
2. Veritabanındaki tüm tabloları listeleyen `sqlite_master` tablosunu sorgulamak için UNION ekler
3. `--` orijinal sorgunun geri kalanını yorum satırına dönüştürür

**Sonuç:** Saldırgan tüm veritabanı tablo adlarını görür — tam veritabanı şeması açığa çıkar.

**Oradan:** Saldırgan herhangi bir tabloyu sorgulayabilir, herhangi bir veri çıkarabilir (kullanıcılar, parolalar, kredi kartları vb.)

---

### SQL Injection'ı Önlemenin Üç Yolu

**Yöntem 1: Parametreli Sorgular (app2.py güvenli versiyonundan)**

```python
# DOĞRU (GÜVENLİ) KULLANIM:
query = "SELECT * FROM users WHERE username = ? AND password = ?"
cur.execute(query, (username, password))   # Parametreler ayrı geçirilir
```

`?` yer tutucuları veritabanı sürücüsü tarafından doldurulur; **tüm özel karakterler escape edilir**. Kullanıcı girdisi veri olarak işlenir, asla SQL kodu olarak değil.

**Yöntem 2: Açık parametreli sorgular (app3.py güvenli versiyonundan)**

```python
query = "SELECT id, name, description FROM products WHERE name = ?"
cur.execute(query, (keyword,))
results = cur.fetchall()
```

Aynı ilke — kullanıcının `keyword`'ü hiçbir zaman SQL metnine birleştirilmez.

**Yöntem 3: ORM (Nesne-İlişkisel Eşleyici) — app3.py'den**

```python
# ORM kullanımı — SQLAlchemy:
products = session.query(Product).filter(Product.name == keyword).all()
```

ORM otomatik olarak parametreli SQL üretir — **hiçbir zaman elle SQL yazmazsınız**, dolayısıyla injection tasarım gereği imkânsızdır.

---

### String Birleştirme Neden Tehlikelidir?

```python
# SAVUNMASIZ — String birleştirme:
query = "SELECT ... WHERE name = '" + keyword + "'"
```

Kullanıcının girdisi doğrudan SQL string'ine eklenir. `keyword` içinde `' OR 1=1 --` varsa sorgu bozulur.

```python
# GÜVENLİ — Parametreli:
query = "SELECT ... WHERE name = ?"
cur.execute(query, (keyword,))
```

Veritabanı sürücüsü escape işlemini yapar. `keyword` içinde `' OR 1=1 --` olsa bile tam olarak `' OR 1=1 --` adında bir ürün araması olarak işlenir — sonuç döndürmez.

---

### SQL Injection Savunma Özeti

| Yaklaşım | Güvenlik | Notlar |
|---|---|---|
| String birleştirme | ❌ Tehlikeli | Asla kullanma |
| Parametreli sorgular | ✅ Güvenli | Her zaman kullan |
| ORM | ✅ Güvenli | Karmaşık uygulamalar için en iyi |
| Yalnızca girdi doğrulama | ⚠️ Kısmi | Tek başına yeterli değil |

---

# DENEME SINAVI

---

<a name="sinav"></a>
## 📝 DENEME SINAVI — 20 Soru

*Her soruyu dikkatlice okuyun ve en iyi cevabı seçin. Tüm soruları cevaplayana kadar cevaplara bakmayın.*

---

**S1.** Bir güvenlik sisteminin "Policy" bileşeni ne anlama gelir?

A) Sistemin hangi teknik mekanizmaları kullandığı
B) Neyin korunacağını ve güvenlik hedeflerini belirleyen strateji
C) Sistemin ne kadar güvenilir olduğunu ölçen test süreci
D) Çalışanların sistemle nasıl etkileşime girdiği

---

**S2.** One-Time Pad şifrelemesi "Perfect Secrecy" sağlar. Bunun pratikte kullanılmasının temel sorunu nedir?

A) Şifre çözme çok yavaştır
B) Anahtarın mesajla aynı uzunlukta olması ve güvenli şekilde iletilmesi gerekmektedir
C) Yalnızca metin şifreleyebilir, sayıları şifreleyemez
D) 128-bit anahtarla kırılabilir

---

**S3.** ECB (Electronic Codebook) modu neden güvensizdir?

A) Şifreleme anahtarı çok kısa olduğu için
B) Aynı plaintext bloğu her zaman aynı ciphertext bloğunu üretir ve desenler sızar
C) Her blok için farklı bir anahtar kullanması gerektiği için
D) CBC moduna göre çok daha yavaş çalıştığı için

---

**S4.** CBC modunda IV (Initialization Vector) kullanılmasının temel amacı nedir?

A) Şifrelemeyi hızlandırmak
B) İlk blokun deterministik şifrelenmesini engellemek ve aynı mesajın her seferinde farklı görünmesini sağlamak
C) Anahtarın uzunluğunu artırmak
D) Padding ihtiyacını ortadan kaldırmak

---

**S5.** AES-CTR modunda aynı (Anahtar, Nonce) çifti iki farklı mesaj için kullanılırsa ne olur?

A) İkinci mesaj şifrelenmez
B) İki ciphertext'in XOR'u alınarak her iki plaintext de kurtarılabilir
C) Anahtar otomatik olarak değişir
D) Yalnızca bütünlük ihlali oluşur, gizlilik etkilenmez

---

**S6.** SHA-256'nın MD5'e göre daha güvenli olmasının temel nedeni nedir?

A) SHA-256 daha hızlı çalışır
B) SHA-256 çıktısı daha uzun olduğu için collision bulmak hesaplama açısından çok zordur ve iç yapısı daha sağlamdır
C) SHA-256 salt kullanımını zorunlu kılar
D) MD5 yalnızca Windows'ta çalışır

---

**S7.** Parolası "123456" olan iki farklı kullanıcı vardır. Salt kullanılmazsa veritabanında ne görünür?

A) İki farklı hash değeri — salt olmasa da her kullanıcı için farklıdır
B) Aynı hash değeri — saldırgan tek bir hash kırarak her iki hesaba erişir
C) Şifreler plaintext olarak saklanır
D) Veritabanı bu durumu otomatik engeller

---

**S8.** Rainbow Table saldırısı, Salt kullanımıyla nasıl etkisiz hale getirilir?

A) Salt, hash fonksiyonunu daha yavaş yapar
B) Her kullanıcı için farklı bir hash üretildiğinden önceden hazırlanmış tablolar işe yaramaz
C) Salt, şifreyi daha uzun yapar
D) Salt, veritabanındaki hash değerlerini gizler

---

**S9.** Aşağıdaki Python kodu neden güvensizdir?
```python
query = f"SELECT * FROM users WHERE username = '{username}' AND password = '{password}'"
cur.execute(query)
```

A) Veritabanı bağlantısı şifrelenmemiştir
B) Kullanıcı girdisi doğrudan SQL sorgusuna eklenmektedir, SQL Injection'a açıktır
C) f-string kullanımı Python'da yasaktır
D) SQLite bu sorgu türünü desteklemez

---

**S10.** ORM kullanımı SQL Injection'ı nasıl önler?

A) Tüm SQL sorgularını şifreler
B) SQL metni elle birleştirilmez — ORM parametreli sorgular üretir
C) Veritabanı erişimini tamamen engeller
D) Kullanıcı girdisini otomatik temizler

---

**S11.** Replay saldırısı nedir ve nasıl önlenir?

A) Saldırgan şifre anahtarını çalar; önlem olarak şifre değiştirilir
B) Saldırgan geçerli bir mesajı kaydedip tekrar gönderir; önlem olarak nonce veya timestamp kullanılır
C) Saldırgan mesajı değiştirerek iletir; önlem olarak hash kullanılır
D) Saldırgan sahte bir sunucu kurar; önlem olarak sertifika kullanılır

---

**S12.** Kerberos protokolünde TGT (Ticket Granting Ticket) ne işe yarar?

A) Şifreleme anahtarı olarak kullanılır
B) Kullanıcının her servise ayrı oturum açmasını engelleyen; kimliği KDC'ye bir kez kanıtladıktan sonra servis bileti almasını sağlayan bilet
C) Sunucuların birbirini tanıması için kullanılır
D) Replay saldırılarını tespit eden bir mekanizmadır

---

**S13.** Vigenère şifrelemesinde "Kasiski Testi" ne yapar?

A) Anahtarın tüm kombinasyonlarını dener
B) Şifreli metindeki tekrarlayan kalıplardan anahtar kelime uzunluğunu tahmin eder
C) Şifreli metni çözümlemek için frekans analizi uygular
D) Anahtarın gücünü matematiksel olarak hesaplar

---

**S14.** Bir araç keyless entry sistemi Ultra Wideband (UWB) teknolojisine geçmiştir. Bu geçişin temel güvenlik amacı nedir?

A) Şifreleme algoritmasını güçlendirmek
B) Sinyal iletim süresini (Time-of-Flight) nanosecond hassasiyetinde ölçerek gerçek fiziksel mesafeyi doğrulamak ve relay saldırısını önlemek
C) Pil ömrünü uzatmak
D) Araca daha hızlı bağlanmayı sağlamak

---

**S15.** "Avalanche Effect" hash fonksiyonlarında ne anlama gelir?

A) Büyük girdiler büyük çıktı üretir
B) Girdideki küçük bir değişiklik, çıktıda büyük ve tahmin edilemez değişikliklere yol açar
C) Hash değerleri rastgele sırayla üretilir
D) Hash hesaplamak büyük miktarda bellek gerektirir

---

**S16.** TOFU (Trust On First Use) modelinin temel riski nedir?

A) Her bağlantıda yeni bir anahtar gerektirmesi
B) İlk bağlantıda bir saldırgan meşru taraftan önce bağlanırsa sistemi kontrol edebilir
C) Çok fazla hesaplama kaynağı tüketmesi
D) Yalnızca simetrik şifreleme ile çalışması

---

**S17.** Nation-state saldırılarını diğer tehdit aktörlerinden ayıran en önemli özellik nedir?

A) Yalnızca fiziksel saldırı yöntemlerini kullanmaları
B) Uzun vadeli, sabırlı, stratejik ve çok kaynaklı olmaları
C) Yalnızca finansal kazanç amaçlamaları
D) Açık kaynaklı araçlar kullanmaları

---

**S18.** Bir kullanıcı şifre veritabanının çalındığını öğreniyor. Sistem bcrypt + salt kullandıysa gerçekçi risk değerlendirmesi nasıldır?

A) Tüm şifreler anında ifşa olmuştur
B) Salt ve bcrypt'in yavaş yapısı sayesinde şifreler pratik olarak güvende olmakla birlikte yine de değiştirilmelidir
C) Bcrypt çift yönlü olduğundan şifreler kolayca çözülür
D) Yalnızca kısa şifreler risk altındadır, uzun şifreler tamamen güvendedir

---

**S19.** Needham-Schroeder protokolünün temel zafiyeti nedir ve Kerberos bunu nasıl çözer?

A) Anahtar uzunluğu çok kısa; Kerberos daha uzun anahtarlar kullanır
B) Eski session key'ler replay saldırısına açıktır; Kerberos zaman damgası ekleyerek bu saldırıyı engeller
C) Protokol açık anahtar kriptografisi kullanmaz; Kerberos RSA kullanır
D) Güven sunucusu gerektirir; Kerberos P2P çalışır

---

**S20.** Reflection attack ile relay attack arasındaki temel fark nedir?

A) Relay fiziksel, reflection ise yazılım tabanlıdır
B) Reflection attack sistemin kendi challenge mesajını kendi cevabına karşı kullanır; relay attack ise sinyali fiziksel olarak uzaktan iletir
C) İkisi tamamen aynı saldırıdır
D) Relay attack şifre kırmayı gerektirir, reflection attack gerektirmez

---

<a name="cevaplar"></a>
## ✅ CEVAPLAR

| S | Cevap | Açıklama |
|---|---|---|
| **S1** | **B** | Policy = neyi koruyacağımızı tanımlar. Mechanism = nasıl koruyacağımızı. |
| **S2** | **B** | OTP anahtarı mesaj uzunluğunda olmalı ve güvenli kanal gerekiyor — pratik değil. |
| **S3** | **B** | Aynı plaintext → aynı ciphertext → desen sızar (Penguen örneği). |
| **S4** | **B** | IV ilk bloğa eklenince aynı mesaj farklı başlangıç noktasından şifrelenir → farklı çıktı. |
| **S5** | **B** | C1 ⊕ C2 = P1 ⊕ P2 — nonce yeniden kullanım felaketi. |
| **S6** | **B** | 256-bit çıktı + güçlü iç yapı. MD5'in iç yapısı zayıf → collision bulunabilir. |
| **S7** | **B** | Salt yoksa aynı şifre → aynı hash. Saldırgan bir kırarak ikisine birden erişir. |
| **S8** | **B** | Her kullanıcıya farklı salt → her kullanıcı için farklı hash → önceden hazırlanmış tablo işe yaramaz. |
| **S9** | **B** | String birleştirme doğrudan SQL'e ekleniyor → SQL Injection. |
| **S10** | **B** | ORM SQL metnini elle birleştirmez, parametreli sorgu üretir. |
| **S11** | **B** | Replay = eski mesajı tekrar gönder. Nonce/timestamp = mesaj tazeliği, eski mesajlar reddedilir. |
| **S12** | **B** | TGT ile kullanıcı her servise ayrı ayrı login olmadan bilet alabilir. |
| **S13** | **B** | Kasiski: tekrar eden bloklar anahtar uzunluğunu ele verir. |
| **S14** | **B** | UWB Time-of-Flight ölçümü → gerçek fiziksel mesafe → relay saldırısı tespit edilir. |
| **S15** | **B** | Çığ etkisi = küçük giriş değişikliği → büyük, öngörülmez çıktı değişikliği. |
| **S16** | **B** | İlk bağlanan meşru tarafsa TOFU güvenlidir. Saldırgan önce bağlanırsa sistemi ele geçirir. |
| **S17** | **B** | Devletler en güçlü saldırganlar: sabırlı, gizli, stratejik, iyi kaynaklı. |
| **S18** | **B** | bcrypt yavaş → GPU ile kırmak astronomik süre alır. Ama yine de şifreler değiştirilmeli. |
| **S19** | **B** | Needham-Schroeder'da eski session key replay'e açık. Kerberos zaman damgasıyla önler. |
| **S20** | **B** | Reflection: sistemin kendi cevabını çalar. Relay: sinyal fiziksel olarak uzatılır. |

---

## 📌 HIZLI BAŞVURU KARTI

### Güvenlik Özellikleri
- **CIA:** Gizlilik, Bütünlük, Erişilebilirlik
- **Kimlik Doğrulama:** Kim olduğunuz?
- **Yetkilendirme:** Ne yapabilirsiniz?
- **Hesap Verebilirlik:** Ne yaptınız?

### AES Modları Özet
- **ECB:** ❌ Asla kullanma (desen sızar)
- **CBC:** ⚠️ Eski sistemler, sıralı, Padding Oracle riski
- **CTR:** ✅ İyi, paralel, akış benzeri
- **GCM:** ✅✅ En iyi — şifreleme + kimlik doğrulama

### Hash Fonksiyonu Hiyerarşisi
- **Kırık:** MD5, SHA-1
- **Güvenli:** SHA-256, SHA-3
- **Parola saklama:** bcrypt, Argon2 (salt + pepper ile)

### SQL Injection Önleme
1. Parametreli sorgular (her zaman)
2. ORM (karmaşık uygulamalar için en iyi)
3. Kullanıcı girdisini asla SQL'e birleştirme

### Temel Saldırı Adları
- **Replay:** Eski mesaj tekrar gönderilir
- **Relay:** Sinyal fiziksel olarak iletilir (anahtarsız araç)
- **Reflection:** Sistemin kendi challenge'ı kendi cevabına karşı kullanılır (MIG saldırısı)
- **MITM:** Saldırgan iki taraf arasına girer
- **Nonce Yeniden Kullanımı:** CTR/OTP anahtar yeniden kullanımı → P1⊕P2 açığa çıkar
- **Padding Oracle:** CBC padding hatası plaintext'i açığa çıkarır

---

*Çalışma Rehberi Sonu — Sınavda başarılar! 🎯*
