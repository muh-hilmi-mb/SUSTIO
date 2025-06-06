# File: app.R - Final Version with Login + TPA Search Feature

library(shiny)
library(leaflet)
library(DT)
library(shinyjs)
library(bslib)
library(shinycssloaders)

# Data lokasi pengelolaan sampah terbaru
data_tpa <- data.frame(
  nama = c(
    "Cemara Trashion",
    "Bank Sampah Tresno Tuhutentrem",
    "Pengelolaan Sampah Mandiri KASTURI",
    "Butik Daur Ulang - Project B Indonesia",
    "Bank Sampah Surolaras",
    "Bank Sampah Simul 5",
    "Bank Sampah BERSERI 35 Bumijo",
    "The Paper Hunter",
    "Bank Sampah Gemah Ripah"
  ),
  alamat = c(
    "Pringwulung, Sleman DIY",
    "Jl. Sorosutan No.26, Umbulharjo, Yogyakarta",
    "Karangasem, Gempol, Condong Catur, Sleman",
    "Jalan Sukoharjo 132A, Condongcatur, Sleman",
    "Jl. Suronatan Blok NG-2/51, Notoprajan, Ngampilan",
    "Jl. Sidomulyo No. 345, Bener, Tegalrejo, Yogyakarta",
    "Jl. Bumijo Kulon No. I, Jetis, Yogyakarta",
    "Jl. Narada 33b, Gandok, Condong Catur, Sleman",
    "Jl. Urip Sumoharjo Dk, Badegan RT 12, Bejen, Bantul"
  ),
  lat = c(-7.7555, -7.8202, -7.7520, -7.7515, -7.8013, -7.7891, -7.7899, -7.7522, -7.9167),
  lng = c(110.3933, 110.3897, 110.4092, 110.4098, 110.3564, 110.3511, 110.3605, 110.4101, 110.3395),
  kapasitas = c(85, 45, 70, 30, 60, 90, 25, 50, 75),
  jenis = c("Bank Sampah", "Bank Sampah", "TPA", "Daur Ulang", "Bank Sampah", "Bank Sampah", "Bank Sampah", "Daur Ulang", "Bank Sampah"),
  stringsAsFactors = FALSE
)

data_umkm <- data.frame(
  nama = c("DESA WISATA GERABAH KASONGAN", "SENTRA KERAJINAN WAYANG DUSUN PUCUNG", "SENTRA BAMBU DESA MUNTUK", "SENTRA KERAJINAN DESA WUKIRSARI"),
  produk = c("ROTAN, BATOK KELAPA, BAMBU, KAYU", "AKSESORIS", "CENDERA MATA, ALAT MASAK, PERABOTAN RUMAH TANGGA", "KERANJANG KUE, ALAT RUMAH TANGGA DARI ROTAN"),
  alamat = c("Jl. Kasongan No.3, Kajen, Bangunjiwo, Kec. Kasihan, Kabupaten Bantul, Daerah Istimewa Yogyakarta 55184", "Pucung, Planjan, Kec. Saptosari, Kabupaten Gunungkidul, Daerah Istimewa Yogyakarta 55871", "Karang Asem, Muntuk, Kec. Dlingo, Kabupaten Bantul, Daerah Istimewa Yogyakarta 55783", "Dusun Giriloyo, Desa Wukirsari RT.02 / RW.20, Imogiri, Karang Kulon, Wukirsari, Kec. Imogiri, Kabupaten Bantul, Daerah Istimewa Yogyakarta 55782")
)

user_base <- data.frame(
  username = c("admin", "user1"),
  password = c("admin123", "pass123"),
  permissions = c("admin", "standard"),
  stringsAsFactors = FALSE
)

komentar_data <- data.frame(Nama = character(), Komentar = character(), Waktu = character())

ui <- fluidPage(
  useShinyjs(),
  theme = bs_theme(version = 5, bootswatch = "flatly", primary = "#2c3e50", secondary = "#18bc9c"),
  tags$head(tags$style(HTML(".navbar { border-bottom: 2px solid #18bc9c; } .card { margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); } .list-group-item { border: none; } footer { background-color: #f8f9fa; padding: 20px; margin-top: 40px; } #login_btn { margin-right: 10px; } .login-modal { padding: 20px; } .progress { height: 25px; margin-bottom: 10px; } .progress-bar-green { background-color: #2ecc71; } .progress-bar-yellow { background-color: #f39c12; } .progress-bar-red { background-color: #e74c3c; } .location-card { margin-bottom: 15px; border-left: 4px solid #18bc9c; } .location-title { font-weight: bold; color: #2c3e50; } .location-type { font-style: italic; color: #7f8c8d; } .map-container { height: 500px; border-radius: 8px; overflow: hidden; }"))),
  
  hidden(
    div(
      id = "main_content",
      navbarPage(
        title = div(span(style = "font-size: 24px; margin-right: 10px;", "♻"), "SUSTIOㅤㅤㅤ"),
        id = "mainNav",
        collapsible = TRUE,
        
        tabPanel("ㅤㅤㅤTPA/Bank Sampahㅤㅤㅤ",
                 fluidRow(
                   column(8, leafletOutput("peta_lokasi") %>% withSpinner(type = 4, color = "#18bc9c")),
                   column(4,
                          selectInput("filter_jenis", "Filter Jenis:", choices = c("Semua", unique(data_tpa$jenis)), selected = "Semua"),
                          textInput("search_nama", "Cari Lokasi:", placeholder = "Nama lokasi..."),
                          div(style = "max-height: 500px; overflow-y: auto;", uiOutput("lokasi_ui"))
                   )
                 )
        ),
        
        tabPanel("ㅤㅤㅤForumㅤㅤㅤ",
                 div(class = "container-fluid",
                     card(
                       card_header("Forum Diskusi Pengelolaan Sampah"),
                       card_body(
                         textInput("nama_pengguna", "Nama Pengguna", placeholder = "Masukkan nama Anda"),
                         textAreaInput("komentar", "Komentar", "", placeholder = "Tulis komentar Anda...", rows = 4),
                         actionButton("kirim", "Kirim Komentar", class = "btn-primary"),
                         hr(),
                         DTOutput("tabel_komentar") %>% withSpinner(type = 4, color = "#18bc9c")
                       )
                     )
                 )
        ),
        
        tabPanel("ㅤㅤㅤEdukasiㅤㅤㅤ",
                 div(class = "container-fluid",
                     card(
                       card_header("Materi Edukasi Daur Ulang"),
                       card_body(
                         accordion(
                           accordion_panel("Pemilahan Sampah", icon = icon("recycle"),
                                           p("ㅤㅤㅤPemilahan sampah merupakan langkah awal yang penting dalam pengelolaan lingkungan yang berkelanjutan. Dengan memisahkan sampah berdasarkan jenisnya, seperti organik, anorganik, dan B3 (bahan berbahaya dan beracun), masyarakat dapat membantu mengurangi volume sampah yang berakhir di tempat pembuangan akhir. Sampah organik seperti sisa makanan dan daun dapat diolah menjadi kompos, sementara sampah anorganik seperti plastik dan kertas bisa didaur ulang menjadi barang berguna. Dengan demikian, pemilahan sampah mendukung upaya pengurangan pencemaran lingkungan dan penghematan sumber daya alam."),
                                           p("ㅤㅤㅤSelain manfaat lingkungan, pemilahan sampah juga membuka peluang ekonomi, khususnya bagi pelaku usaha daur ulang dan UMKM yang bergerak di bidang kerajinan dari limbah. Edukasi kepada masyarakat mengenai pentingnya memilah sampah perlu terus digalakkan sejak usia dini agar budaya ini dapat menjadi kebiasaan. Dukungan dari pemerintah dalam bentuk kebijakan dan fasilitas penunjang juga sangat diperlukan untuk memperkuat sistem pemilahan sampah di tingkat rumah tangga hingga industri. Dengan kolaborasi semua pihak, pemilahan sampah dapat menjadi solusi nyata dalam menciptakan lingkungan yang bersih dan sehat.")
                           ),
                           accordion_panel("Daur Ulang Kreatif", icon = icon("paint-brush"),
                                           p("ㅤㅤㅤDaur ulang kreatif adalah proses mengubah sampah atau barang bekas menjadi produk baru yang memiliki nilai guna dan estetika tinggi. Berbeda dengan daur ulang biasa, daur ulang kreatif lebih menekankan pada aspek seni dan inovasi, seperti mengubah botol plastik menjadi pot tanaman hias atau membuat tas dari kemasan kopi bekas. Kegiatan ini tidak hanya membantu mengurangi jumlah sampah, tetapi juga mendorong masyarakat untuk lebih peduli terhadap lingkungan dengan cara yang menarik dan menyenangkan."),
                                           p("ㅤㅤㅤSelain bermanfaat bagi lingkungan, daur ulang kreatif juga dapat menjadi peluang bisnis yang menjanjikan. Banyak pelaku UMKM dan pengrajin lokal yang berhasil menciptakan produk unik dan bernilai jual tinggi dari limbah rumah tangga. Dengan sedikit kreativitas dan keterampilan, sampah bisa disulap menjadi barang fungsional dan bernilai seni, sekaligus memberikan dampak positif bagi ekonomi masyarakat. Melalui daur ulang kreatif, kita dapat berkontribusi dalam menjaga kelestarian lingkungan sekaligus mendorong pertumbuhan ekonomi hijau.")
                           ),
                           accordion_panel("Dampak Sampah bagi Lingkungan", icon = icon("leaf"),
                                           p("ㅤㅤㅤSampah yang tidak dikelola dengan baik dapat menimbulkan berbagai dampak negatif bagi lingkungan. Penumpukan sampah di tempat terbuka dapat mencemari tanah dan air, karena zat berbahaya dari sampah bisa meresap ke dalam tanah atau terbawa air hujan ke sungai dan laut. Selain itu, sampah organik yang membusuk menghasilkan gas metana, salah satu gas rumah kaca yang berkontribusi terhadap perubahan iklim. Sampah plastik yang sulit terurai juga menjadi ancaman serius karena dapat mencemari ekosistem dan membahayakan kehidupan hewan."),
                                           p("ㅤㅤㅤDampak lainnya adalah gangguan kesehatan bagi manusia. Sampah yang menumpuk bisa menjadi sarang bagi vektor penyakit seperti lalat, tikus, dan nyamuk, yang dapat menyebarkan penyakit berbahaya. Selain itu, pencemaran udara akibat pembakaran sampah juga dapat menyebabkan gangguan pernapasan. Oleh karena itu, penting bagi setiap individu untuk mengelola sampah dengan bijak, mulai dari mengurangi penggunaan barang sekali pakai, melakukan pemilahan sampah, hingga mendukung program daur ulang demi menjaga kelestarian lingkungan.")
                           )
                         )
                       )
                     )
                 )
        ),
        
        tabPanel("ㅤㅤㅤProdukㅤㅤㅤ",
                 div(class = "container-fluid",
                     card(
                       card_header("UMKM Pengrajin Daur Ulang"),
                       card_body(DTOutput("tabel_umkm") %>% withSpinner(type = 4, color = "#18bc9c"))
                     )
                 )
        ),
        
        tabPanel("ㅤㅤㅤTentang Kamiㅤㅤㅤ",
                 div(class = "container-fluid",
                     card(
                       card_header("Tentang Proyek"),
                       card_body(
                         h4("SUSTIO - Data & Forum untuk Masa Depan Berkelanjutan"),
                         p("Mata Kuliah: R Programming"),
                         p("Kelas: BR1"),
                         p("Dosen Pengampu: Dr. Lukman Heryawan, S.T., M.T."),
                         hr(),
                         h4("Tim Pengembang: Kelompok 9"),
                         div(class = "list-group",
                             lapply(list(
                               "Muhammad Hilmi Mishbahuddin Bahy (24/534835/EK/24926)",
                               "Haidar Ziyya Ahmad Ghazali Husen (24/537654/EK/25040)",
                               "Rahayu Ingratrimulya Saputri (24/537960/EK/25064)",
                               "Jonathan Cahaya Kristianto (24/543391/EK/25286)",
                               "Raissa Maharani (24/542812/EK/25262)",
                               "Destiana Wicaksani (24/536157/EK/24971)",
                               "Serina (24/541759/EK/25183)"
                             ), function(x) div(class = "list-group-item", x))
                         )
                       )
                     ),
                     card(
                       card_header("Institusi"),
                       card_body(
                         p("FAKULTAS EKONOMIKA DAN BISNIS"),
                         p("UNIVERSITAS GADJAH MADA"),
                         p("YOGYAKARTA"),
                         p("2025")
                       )
                     )
                 )
        )
      ),
      tags$footer(class = "text-center",
                  p("© 2025 Kelompok 9 R Programming FEB UGM |", tags$a(href = "mailto:muhammadhilmimishbah@mail.ugm.ac.id", "Contact Us"))
      )
    )
  )
)

server <- function(input, output, session) {
  values <- reactiveValues(data = komentar_data, user = NULL, login_state = FALSE)
  
  observe({
    showModal(modalDialog(
      title = "Login ke SUSTIO",
      textInput("user_name", "Username", placeholder = "Masukkan username"),
      passwordInput("passwd", "Password", placeholder = "Masukkan password"),
      footer = tagList(
        actionButton("login", "Login", class = "btn-primary"),
        actionButton("register", "Daftar", class = "btn-secondary"),
        modalButton("Tutup")
      ),
      easyClose = FALSE
    ))
  })
  
  observeEvent(input$login, {
    username <- input$user_name
    password <- input$passwd
    if (username %in% user_base$username) {
      row_num <- which(user_base$username == username)
      if (user_base$password[row_num] == password) {
        values$user <- username
        values$login_state <- TRUE
        removeModal()
        showNotification(paste("Selamat datang,", username), type = "message")
        shinyjs::show("main_content")
      } else {
        showNotification("Password salah", type = "error")
      }
    } else {
      showNotification("Username tidak ditemukan", type = "error")
    }
  })
  
  observeEvent(input$register, {
    username <- input$user_name
    password <- input$passwd
    if (nchar(username) < 3) {
      showNotification("Username harus minimal 3 karakter", type = "error"); return()
    }
    if (nchar(password) < 5) {
      showNotification("Password harus minimal 5 karakter", type = "error"); return()
    }
    if (username %in% user_base$username) {
      showNotification("Username sudah terdaftar", type = "error")
    } else {
      user_base <<- rbind(user_base, data.frame(username = username, password = password, permissions = "standard", stringsAsFactors = FALSE))
      showNotification("Pendaftaran berhasil! Silakan login.", type = "message")
    }
  })
  
  observeEvent(input$kirim, {
    if (!values$login_state) {
      showNotification("Anda harus login untuk mengirim komentar", type = "error"); return()
    }
    if (nzchar(input$nama_pengguna) && nzchar(input$komentar)) {
      new_entry <- data.frame(Nama = input$nama_pengguna, Komentar = input$komentar, Waktu = format(Sys.time(), "%d %b %Y %H:%M"))
      values$data <- rbind(values$data, new_entry)
      reset("nama_pengguna"); reset("komentar")
      showNotification("Komentar berhasil dikirim!", type = "message")
    } else {
      showNotification("Harap isi nama dan komentar!", type = "error")
    }
  })
  
  observe({
    df <- data_tpa
    if (!is.null(input$filter_jenis) && input$filter_jenis != "Semua") {
      df <- df[df$jenis == input$filter_jenis, ]
    }
    if (!is.null(input$search_nama) && nzchar(input$search_nama)) {
      df <- df[grepl(input$search_nama, df$nama, ignore.case = TRUE) |
                 grepl(input$search_nama, df$alamat, ignore.case = TRUE), ]
    }
    values$tpa <- df
  })
  
  output$peta_lokasi <- renderLeaflet({
    leaflet(values$tpa) %>%
      addTiles() %>%
      addMarkers(
        lng = ~lng,
        lat = ~lat,
        popup = ~paste("<b>", nama, "</b><br>", "Alamat: ", alamat, "<br>", "Jenis: ", jenis, "<br>", "Kapasitas: ", kapasitas, "%"),
        clusterOptions = markerClusterOptions()
      ) %>%
      addProviderTiles(providers$CartoDB.Positron)
  })
  
  output$lokasi_ui <- renderUI({
    lapply(1:nrow(values$tpa), function(i) {
      lokasi <- values$tpa[i, ]
      warna <- if (lokasi$kapasitas > 75) "progress-bar-red" else if (lokasi$kapasitas > 50) "progress-bar-yellow" else "progress-bar-green"
      div(class = "card location-card",
          div(class = "card-body",
              h5(class = "card-title location-title", lokasi$nama),
              h6(class = "card-subtitle mb-2 location-type", lokasi$jenis),
              p(class = "card-text", lokasi$alamat),
              div(class = "progress",
                  div(class = paste("progress-bar", warna), role = "progressbar", style = paste0("width: ", lokasi$kapasitas, "%"), `aria-valuenow` = lokasi$kapasitas, `aria-valuemin` = "0", `aria-valuemax` = "100", paste0("Kapasitas: ", lokasi$kapasitas, "%"))
              )
          )
      )
    })
  })
  
  output$tabel_komentar <- renderDT({
    datatable(
      values$data,
      options = list(
        pageLength = 5,
        order = list(2, 'desc'),
        language = list(url = '//cdn.datatables.net/plug-ins/1.10.21/i18n/Indonesian.json')
      ),
      rownames = FALSE,
      class = "compact stripe hover"
    ) %>% formatStyle(columns = 1:3, fontSize = "14px")
  })
  
  output$tabel_umkm <- renderDT({
    datatable(
      data_umkm,
      options = list(
        pageLength = 5,
        language = list(url = '//cdn.datatables.net/plug-ins/1.10.21/i18n/Indonesian.json')
      ),
      rownames = FALSE,
      class = "compact stripe hover",
      colnames = c("Nama UMKM", "Produk", "Alamat")
    )
  })
}

shinyApp(ui, server)
