//
//  KullaniciRezervasyonlarView.swift
//  rezervisApp
//
//  Created by Oktay Aydın on 9.03.2025.
//

/*
import SwiftUI

struct KullaniciRezervasyonlarView: View {
    
    var secilenServisler: [Servis]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Rezervasyonlarım")
                    .font(.title)
                    .padding()
                
                List {
                    ForEach(secilenServisler, id: \.id) { servis in
                        VStack(alignment: .leading) {
                            Text("\(servis.kalkisYeri) → \(servis.varisyeri)")
                                .font(.headline)
                            Text("Kalkış Saati: \(servis.kalkisSaati)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("Tarih: \(servis.tarih)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                }
                .navigationTitle("Rezervasyonlarım")
            }
        }
    }
}
*/

import SwiftUI

struct KullaniciRezervasyonlarView: View {
    
    var secilenServisler: [Servis]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Spacer()

                    ForEach(secilenServisler, id: \.id) { servis in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "bus")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.blue)
                                
                                VStack(alignment: .leading) {
                                    Text("\(servis.kalkisYeri) → \(servis.varisyeri)")
                                        .font(.headline)
                                    
                                    Text("Kalkış: \(servis.kalkisSaati) - \(servis.tarih)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Text("Boş Koltuk Sayısı: \(servis.koltukSayisi)")
                                .font(.footnote)
                                .foregroundColor(Int(servis.koltukSayisi) > 5 ? .green : .red)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom)
            }
            .navigationTitle("Rezervasyonlarım")
        }
    }
}


#Preview {
    
    KullaniciRezervasyonlarView(secilenServisler: [
        Servis(id: "1", kalkisYeri: "Kadıköy", varisyeri: "Okan Üniversitesi", tarih: "10.04.2025", kalkisSaati: "08:00", koltukSayisi: 20),
        Servis(id: "2", kalkisYeri: "Otogar", varisyeri: "Teknopark", tarih: "11.04.2025", kalkisSaati: "09:00", koltukSayisi: 15)
    ])
}

