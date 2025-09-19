//
//  YoneticiAnaEkran.swift
//  rezervisApp
//
//  Created by Oktay Aydın on 8.03.2025.
//

import SwiftUI

struct YoneticiAnaEkran: View {
    
    @ObservedObject var servisSinifi = veriModeli()
        
    @State private var secilenServisler: [Servis] = []
    @State private var seciliServis: Servis? = nil
    @State private var rezervasyonSayfasinaGit = false
    @State private var rezervasyonOnayinaGit = false
    
    /*
    let rezervasyonlar = [
        ("Merkez", "Üniversite", "08:00", 10),
        ("Otogar", "Teknopark", "09:00", 5)
    ]
     */
    
    @State private var servisEkle = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Rezervasyon Yönetimi")
                    .font(.title)
                    .padding()
                
                
                List {
                    ForEach(servisSinifi.servisListesi, id: \.id) { item in
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
                    }
                }

                
                NavigationLink(
                    isActive: $rezervasyonOnayinaGit,
                    destination: {
                        Group {
                            if let servis = seciliServis {
                                RezervasyonOnayView(servis: servis)
                            } else {
                                Text("Servis seçilmedi")
                            }
                        }
                    },
                    label: {
                        EmptyView()
                    }
                )
                
                 
                /*
                List(rezervasyonlar, id: \.0) { rezervasyon in
                    VStack(alignment: .leading) {
                        Text("\(rezervasyon.0) → \(rezervasyon.1)")
                            .font(.headline)
                        Text("Kalkış Saati: \(rezervasyon.2)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("Toplam Rezervasyon: \(rezervasyon.3)")
                            .font(.footnote)
                            .foregroundColor(rezervasyon.3 > 5 ? .green : .red)
                    }
                    .padding()
                }
                 */
            }
            .navigationTitle("Yönetici Rezervasyon")
        }
        
        Button(action: {
            servisEkle = true
        }) {
            Text("Servis Ekle")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.horizontal)
        }
        .sheet(isPresented: $servisEkle) {
            YoneticiServisEkleView()
        }
    }
    init(){
        servisSinifi.veriAlma()
    }
    /*
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
     */
}

#Preview {
    YoneticiAnaEkran()
}

