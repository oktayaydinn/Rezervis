//
//  RezervasyonOnayView.swift
//  rezervisApp
//
//  Created by Oktay Aydın on 9.03.2025.
//

import SwiftUI

struct RezervasyonOnayView: View {
    
    let servis: Servis
    @State private var rezervasyonTamamlandi = false
    
    var body: some View {
        VStack {
            Text("Rezervasyon Onayı")
                .font(.title)
                .padding()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("🚍 Servis: \(servis.kalkisYeri) → \(servis.varisyeri)")
                Text("⏰ Kalkış Saati: \(servis.kalkisSaati)")
                Text("📅 Tarih: \(servis.tarih)")
                Text("🪑 Boş Koltuk: \(servis.koltukSayisi)")
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
            .padding()
            
            Button(action: {
                rezervasyonTamamlandi = true
            }) {
                Text("Rezervasyonu Tamamla")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .navigationTitle("Onay")
        .alert(isPresented: $rezervasyonTamamlandi) {
            Alert(title: Text("Başarılı ✅"), message: Text("Rezervasyon tamamlandı!"), dismissButton: .default(Text("Tamam")))
        }
    }
}

#Preview {
    RezervasyonOnayView(servis: Servis(id: "1", kalkisYeri: "Kadıköy", varisyeri: "Okan Üniversitesi", tarih: "10.04.2025", kalkisSaati: "08:00", koltukSayisi: 15))
}
