//
//  YoneticiServisEkleView.swift
//  rezervisApp
//
//  Created by Oktay Aydın on 9.03.2025.
//


import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct YoneticiServisEkleView: View {
    
    @State private var kalkisYeri = ""
    @State private var varisYeri = ""
    @State private var saat = ""
    @State private var tarih = ""
    @State private var koltukSayisi = 0
    @State private var hataMesaji = ""
    @State private var eklemeBasarili = false
    @State public var serviceId = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Yeni Servis Ekle")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                TextField("Kalkış Yeri", text: $kalkisYeri)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocapitalization(.none)
                
                TextField("Varış Yeri", text: $varisYeri)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocapitalization(.none)
                
                TextField("Saat (örn: 08:30)", text: $saat)
                    .keyboardType(.numbersAndPunctuation)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                DatePicker("Tarih Seç", selection: stringToDateBinding(), displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .padding(.horizontal)
                
                TextField("Koltuk Sayısı", value: $koltukSayisi, format: .number)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .overlay(
                        HStack {
                            if koltukSayisi == 0 {
                                Text("Koltuk Sayısı")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 10)
                            }
                        }
                    )
                /*
                    .onChange(of: koltukSayisi) { newValue in
                        let filtered = newValue.filter { $0.isNumber }
                        koltukSayisi = filtered
                    }
                */
                
                if !hataMesaji.isEmpty {
                    Text(hataMesaji)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                
                Button(action: {
                    servisBilgileri()
                    control()
                    
                }) {
                    Text("Servisi Ekle")
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
            .padding(.top, 20)
            .alert(isPresented: $eklemeBasarili) {
                Alert(title: Text("Başarılı ✅"), message: Text("Servis başarıyla eklendi!"), dismissButton: .default(Text("Tamam")))
            }
            
            
        }
    }
    
    
    private func control() {
        if kalkisYeri.isEmpty || varisYeri.isEmpty || saat.isEmpty || koltukSayisi <= 0 {
            hataMesaji = "Tüm alanları doldurun!"
        }
        else {
            kalkisYeri = ""
            varisYeri = ""
            saat = ""
            koltukSayisi = 0
            hataMesaji = ""
            eklemeBasarili = true
        }
    }

    private func servisBilgileri() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return}
        //guard (Auth.auth().currentUser?.uid) != nil else { return}
        self.serviceId = uid
        
        let database = Firestore.firestore()
        let newServiceRef = database.collection("services").document() // Yeni belge referansı
        
        let serviceId = newServiceRef.documentID
        
        let servicesData = ["kalkisYeri": self.kalkisYeri, "koltukSayisi": self.koltukSayisi, "saat": self.saat, "tarih": self.tarih, "uid": self.serviceId, "varisYeri": self.varisYeri] as [String : Any]
        
        Firestore.firestore().collection("services")
            .document().setData(servicesData)
    }
    
    func stringToDateBinding() -> Binding<Date> {
            Binding<Date>(
                get: {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yyyy"
                    return formatter.date(from: tarih) ?? Date() // String'ten Date'e çevir
                },
                set: { newDate in
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yyyy"
                    tarih = formatter.string(from: newDate) // Date'ten String'e çevir
                }
            )
        }
}

#Preview {
    YoneticiServisEkleView()
}
