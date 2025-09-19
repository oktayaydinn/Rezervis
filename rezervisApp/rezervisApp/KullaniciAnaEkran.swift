//
//  KullaniciAnaEkran.swift
//  rezervisApp
//
//  Created by Oktay Aydın on 9.03.2025.
//


import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct KullaniciAnaEkran: View {
    
    @ObservedObject var servisSinifi = veriModeli()
    @State private var secilenServisler: [Servis] = []
    @State private var rezervasyonSayfasinaGit = false
    @State private var rezervasyonTamamlandi = false
    @State private var secilenServis: Servis?
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Servis Rezervasyonu Yap")
                    .font(.title)
                    .padding()

                servisListesiView()

                Button {
                    rezervasyonSayfasinaGit = true
                } label: {
                    Text("Rezervasyonlarım")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .sheet(isPresented: $rezervasyonSayfasinaGit) {
                    KullaniciRezervasyonlarView(secilenServisler: secilenServisler)
                }

                NavigationLink(
                    destination: secilenServis != nil ? RezervasyonOnayView(servis: secilenServis!) : nil,
                    isActive: $rezervasyonTamamlandi
                ) {
                    EmptyView()
                }
            }
            .navigationTitle("Rezervasyon")
        }
        .onAppear {
            servisSinifi.veriAlma()
        }
    }

    // Liste görünümü için ayrı fonksiyon yaptım
    @ViewBuilder
    func servisListesiView() -> some View {
        List {
            ForEach(servisSinifi.servisListesi, id: \.id) { item in
                servisSatiriView(item: item)
            }
        }
    }

    // Her bir servis satırı için ayrı View olarak yazdırdım
    @ViewBuilder
    func servisSatiriView(item: Servis) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(item.kalkisYeri) → \(item.varisyeri)")
                    .font(.headline)
                Text("Kalkış Saati: \(item.kalkisSaati)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("Kalkış Tarihi: \(item.tarih)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("Boş Koltuk Sayısı: \(item.koltukSayisi)")
                    .font(.footnote)
                    .foregroundColor(Int(item.koltukSayisi) > 5 ? .green : .red)
            }
            .padding(.vertical, 4)

            Spacer()

            Button(action: {
                secilenServisler.append(item)
                secilenServis = item
                rezervasyonTamamlandi = true

                let db = Firestore.firestore()
                let servisRef = db.collection("services").document(item.id)

                // Servis koltuk sayısını güncelleme
                servisRef.updateData([
                    "koltukSayisi": FieldValue.increment(Int64(-1))
                ]) { error in
                    if let error = error {
                        print("Hata oluştu: \(error.localizedDescription)")
                    } else {
                        print("Koltuk sayısı başarıyla azaltıldı.")
                    }
                }

                // Rezervasyon bilgilerini services/servisID/reservations alt koleksiyonuna ekleme
                let reservationData: [String: Any] = [
                    "userUID": Auth.auth().currentUser?.uid ?? "",
                    "tarih": item.tarih,
                    "koltukSayisi": 1  // Rezervasyonu yapan kullanıcı için 1 koltuk ayarlandı daha sonrasında kullanıcı istediği kadar koltuk rezervasyonu yaptırabilir.
                ]
                
                // Alt koleksiyon'a ekleme yapma komutu
                let rezervasyonRef = servisRef.collection("reservations").addDocument(data: reservationData) { error in
                    if let error = error {
                        print("Rezervasyon eklenirken hata oluştu: \(error.localizedDescription)")
                    } else {
                        print("Rezervasyon başarıyla eklendi.")
                    }
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title)
            }
        }
    }
}

#Preview {
KullaniciAnaEkran()
}

/*

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct KullaniciAnaEkran: View {
    
    @ObservedObject var servisSinifi = veriModeli()
    @State private var secilenServisler: [Servis] = []
    @State private var rezervasyonSayfasinaGit = false
    @State private var rezervasyonTamamlandi = false
    @State private var secilenServis: Servis?
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Servis Rezervasyonu Yap")
                    .font(.title)
                    .padding()

                servisListesiView()

                Button {
                    rezervasyonSayfasinaGit = true
                } label: {
                    Text("Rezervasyonlarım")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .sheet(isPresented: $rezervasyonSayfasinaGit) {
                    KullaniciRezervasyonlarView(secilenServisler: secilenServisler)
                }

                NavigationLink(
                    destination: secilenServis != nil ? RezervasyonOnayView(servis: secilenServis!) : nil,
                    isActive: $rezervasyonTamamlandi
                ) {
                    EmptyView()
                }
            }
            .navigationTitle("Rezervasyon")
        }
        .onAppear {
            servisSinifi.veriAlma()
        }
    }

    //  Liste görünümünü ayrı fonksiyon yaptım
    @ViewBuilder
    func servisListesiView() -> some View {
        List {
            ForEach(servisSinifi.servisListesi, id: \.id) { item in
                servisSatiriView(item: item)
            }
        }
    }

    //  Her bir servis satırı ayrı View olarak yazdırdım
    @ViewBuilder
    func servisSatiriView(item: Servis) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(item.kalkisYeri) → \(item.varisyeri)")
                    .font(.headline)
                Text("Kalkış Saati: \(item.kalkisSaati)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("Kalkış Tarihi: \(item.tarih)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("Boş Koltuk Sayısı: \(item.koltukSayisi)")
                    .font(.footnote)
                    .foregroundColor(Int(item.koltukSayisi) > 5 ? .green : .red)
            }
            .padding(.vertical, 4)

            Spacer()

            Button(action: {
                secilenServisler.append(item)
                secilenServis = item
                rezervasyonTamamlandi = true

                let db = Firestore.firestore()
                let servisRef = db.collection("services").document(item.id)

                servisRef.updateData([
                    "koltukSayisi": FieldValue.increment(Int64(-1))
                ]) { error in
                    if let error = error {
                        print("Hata oluştu: \(error.localizedDescription)")
                    } else {
                        print("Koltuk sayısı başarıyla azaltıldı.")
                        servisSinifi.veriAlma()
                    }
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title)
            }
        }
    }
}

#Preview {
KullaniciAnaEkran()
}




 
 import SwiftUI
 import FirebaseFirestore
 import FirebaseAuth
 
 struct KullaniciAnaEkran: View {
 
 @ObservedObject var servisSinifi = veriModeli()
 @State private var secilenServisler: [Servis] = []
 @State private var rezervasyonSayfasinaGit = false
 @State private var rezervasyonTamamlandi = false
 
 //  Seçilen servis bilgisini burada saklıyoruz
 @State private var secilenServis: Servis?
 
 var body: some View {
 NavigationView {
 VStack {
 Text("Servis Rezervasyonu Yap")
 .font(.title)
 .padding()
 
 List {
 ForEach(servisSinifi.servisListesi, id: \.id) { item in
 HStack {
 VStack(alignment: .leading) {
 Text("\(item.kalkisYeri) → \(item.varisyeri)")
 .font(.headline)
 Text("Kalkış Saati: \(item.kalkisSaati)")
 .font(.subheadline)
 .foregroundColor(.gray)
 Text("Kalkış Tarihi: \(item.tarih)")
 .font(.subheadline)
 .foregroundColor(.gray)
 Text("Boş Koltuk Sayısı: \(item.koltukSayisi)")
 .font(.footnote)
 .foregroundColor(Int(item.koltukSayisi) > 5 ? .green : .red)
 }
 .padding()
 Spacer()
 Button(action: {
 
 
 
 /*
  var guncellenmisServis = item
  if guncellenmisServis.koltukSayisi > 0 {
  guncellenmisServis.koltukSayisi -= 1
  secilenServisler.append(guncellenmisServis)
  secilenServis = guncellenmisServis
  rezervasyonTamamlandi = true
  }
  */
 // Hem listeye ekliyoruz hem de seçilen servisi belirliyoruz
 secilenServisler.append(item)
 secilenServis = item
 rezervasyonTamamlandi = true
 
 let db = Firestore.firestore()
 let servisRef = db.collection("services").document(item.uid)
 
 servisRef.updateData([
 "koltukSayisi": FieldValue.increment(Int64(-1))
 ]) { error in
 if let error = error {
 print("Hata oluştu: \(error.localizedDescription)")
 } else {
 print("Koltuk sayısı başarıyla azaltıldı.")
 }
 }
 
 }) {
 Image(systemName: "plus.circle.fill")
 .foregroundColor(.blue)
 .font(.title)
 }
 }
 }
 }
 
 Button {
 rezervasyonSayfasinaGit = true
 } label: {
 Text("Rezervasyonlarım")
 .font(.headline)
 .foregroundColor(.white)
 .padding()
 .background(Color.blue)
 .cornerRadius(10)
 .padding(.horizontal)
 }
 .sheet(isPresented: $rezervasyonSayfasinaGit) {
 KullaniciRezervasyonlarView(secilenServisler: secilenServisler)
 }
 
 NavigationLink(
 destination: secilenServis != nil ? RezervasyonOnayView(servis: secilenServis!) : nil,
 isActive: $rezervasyonTamamlandi
 ) {
 EmptyView()
 }
 }
 .navigationTitle("Rezervasyon")
 }
 .onAppear {
 servisSinifi.veriAlma()
 }
 }
 }
 
 #Preview {
 KullaniciAnaEkran()
 }
 
 /*
  import SwiftUI
  
  struct KullaniciAnaEkran: View {
  
  @ObservedObject var servisSinifi = veriModeli()
  @State private var secilenServisler: [Servis] = []
  @State private var rezervasyonSayfasinaGit = false
  @State private var rezervasyonTamamlandi = false
  
  
  var body: some View {
  NavigationView {
  VStack {
  Text("Servis Rezervasyonu Yap")
  .font(.title)
  .padding()
  
  Button(action: {
  rezervasyonTamamlandi = true
  }) {
  List {
  ForEach(servisSinifi.servisListesi, id: \.id) { item in
  HStack {
  VStack(alignment: .leading) {
  Text("\(item.kalkisYeri) → \(item.varisyeri)")
  .font(.headline)
  Text("Kalkış Saati: \(item.kalkisSaati)")
  .font(.subheadline)
  .foregroundColor(.gray)
  Text("Kalkış Tarihi: \(item.tarih)")
  .font(.subheadline)
  .foregroundColor(.gray)
  Text("Boş Koltuk Sayısı: \(item.koltukSayisi)")
  .font(.footnote)
  .foregroundColor(Int(item.koltukSayisi) > 5 ? .green : .red)
  }
  .padding()
  Spacer()
  Button(action: {
  secilenServisler.append(item)
  }) {
  Image(systemName: "plus.circle.fill")
  .foregroundColor(.blue)
  .font(.title)
  }
  }
  
  }
  }
  }
  }
  .navigationTitle("Rezervasyon")
  }
  
  Button {
  rezervasyonSayfasinaGit = true
  
  } label: {
  Text("Rezervasyonlarım")
  .font(.headline)
  .foregroundColor(.white)
  .padding()
  .background(Color.blue)
  .cornerRadius(10)
  .padding(.horizontal)
  }
  .sheet(isPresented: $rezervasyonSayfasinaGit) {
  KullaniciRezervasyonlarView(secilenServisler: secilenServisler)
  }
  
  NavigationLink(
  destination: secilenServisler.isEmpty ? nil : RezervasyonOnayView(servis: secilenServisler.last!),
  isActive: $rezervasyonTamamlandi
  ){
  EmptyView()
  }
  
  }
  init(){
  servisSinifi.veriAlma()
  }
  }
  
  
  
  #Preview {
  KullaniciAnaEkran()
  }
  */
 */
