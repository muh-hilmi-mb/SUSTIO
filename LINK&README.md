# LINK
https://mhilmimb.shinyapps.io/SUSTIO/

# ♻️ SUSTIO

### Data & Forum untuk Masa Depan Berkelanjutan

*Kelompok 9 | R Programming | FEB UGM*

## 📌 Deskripsi Proyek

**SUSTIO** adalah sebuah platform digital berbasis Shiny App yang dikembangkan untuk membantu mengatasi permasalahan pengelolaan sampah di Yogyakarta. Platform ini mengintegrasikan:

* **Data lokasi TPA/Bank Sampah**
* **Visualisasi Kapasitas Pengolahan Sampah**
* **Direktori UMKM daur ulang**
* **Forum Diskusi & Edukasi Pengelolaan Sampah**

Tujuan utama dari proyek ini adalah untuk mendukung ekonomi sirkular, meningkatkan kesadaran masyarakat, dan membuka peluang ekonomi dari pengelolaan limbah secara berkelanjutan.

---

## 🎯 Fitur Aplikasi

* **🔒 Login & Register**
  Sistem autentikasi pengguna dengan otorisasi akun `admin` atau `user`.

* **📍 Tab TPA/Bank Sampah**

  * Peta interaktif lokasi pengelolaan sampah di Yogyakarta.
  * Filter berdasarkan jenis lokasi (TPA, Bank Sampah, Daur Ulang).
  * Pencarian nama *dan* alamat lokasi.
  * Indikator kapasitas pengolahan (Hijau = longgar, Kuning = cukup padat, Merah = penuh).

* **💬 Forum**
  Forum diskusi untuk berbagi komentar dan pengalaman terkait pengelolaan sampah.

* **📘 Edukasi**
  Konten pemilahan sampah, daur ulang kreatif, dan dampak lingkungan dari sampah.

* **🧵 Direktori UMKM**
  Tabel informasi produk daur ulang dari UMKM pengrajin lokal Yogyakarta.

* **ℹ️ Tentang Kami**
  Menjelaskan latar belakang proyek dan tim pengembang.

---

## 🛠️ Instalasi

### 1. Prasyarat

Pastikan R dan RStudio telah terinstall, lalu install paket berikut jika belum tersedia:

```r
install.packages(c("shiny", "leaflet", "DT", "shinyjs", "bslib", "shinycssloaders"))
```

### 2. Jalankan Aplikasi

Clone repo ini, lalu jalankan:

```r
shiny::runApp("app.R")
```

---

## 📄 Struktur File

```
📁 SUSTIO/
├── app.R                  # Main Shiny App
├── README.md              # Dokumentasi proyek
└── data/                  # (opsional) folder data jika dipisah
```

---

## 👩‍🔬 Metodologi

* **Pengumpulan Data**: Survei lapangan dan data terbuka DLH Yogyakarta
* **Analisis**: Visualisasi dan deskriptif (volume, kapasitas, distribusi lokasi)
* **Platform**: Aplikasi dibangun menggunakan R Shiny dan Leaflet

---

## 👥 Tim Pengembang

* Muhammad Hilmi Mishbahuddin Bahy
* Haidar Ziyya Ahmad Ghazali Husen
* Rahayu Ingratrimulya Saputri
* Jonathan Cahaya Kristianto
* Raissa Maharani
* Destiana Wicaksani
* Serina

---

## 💡 Lisensi

Hak Cipta © 2025 Kelompok 9 FEB UGM
Lisensi terbuka untuk penggunaan edukatif dan non-komersial.
