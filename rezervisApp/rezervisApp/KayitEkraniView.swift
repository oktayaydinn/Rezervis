//
//  KayitEkraniView.swift
//  rezervisApp
//
//  Created by Oktay Aydın on 7.03.2025.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore


struct KayitEkraniView: View {
    
    @State private var ad = ""
    @State private var soyad = ""
    @State private var okulNumarasi = ""
    @State private var email = ""
    @State private var sifre = ""
    @State private var sifreTekrar = ""
    @State private var hataMesaji = ""
    @State private var kayitBasarili = false
    @State public var kullaniciId = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Öğrenci Kayıt Ekranı")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                TextField("Ad", text: $ad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("Soyad", text: $soyad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("Okul Numarası", text: $okulNumarasi)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("E-posta", text: $email)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocapitalization(.none)
                
                SecureField("Şifre", text: $sifre)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocapitalization(.none)
                
                SecureField("Şifre Tekrar", text: $sifreTekrar)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocapitalization(.none)
                
                if !hataMesaji.isEmpty {
                    Text(hataMesaji)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                
                Button(action: {
                    
                    kayitOlusturma()
                    kullaniciBilgileri()
                }) {
                    Text("Kayıt Ol")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                /*
                 NavigationLink(
                 destination: ContentView(),
                 isActive: $kayitBasarili
                 ) {
                 EmptyView()
                 }
                 */
            }
            .alert(isPresented: $kayitBasarili) {
                Alert(title: Text("Başarılı ✅"), message: Text("Kayıt tamamlandı!"), dismissButton: .default(Text("Tamam")))
            }
            
            Spacer()
            
        }
        .padding(.top, 20)
    }
    
    private func kayitOlusturma() {
        Auth.auth().createUser(withEmail: email, password: sifre) { result, error in
            if error == nil {
                print("Kayıt Başarılı")
                kayitBasarili = true
            }
            else {
                print("Kayıt Başarısız")
            }
            
            self.kullaniciId = "\(result?.user.uid ?? "")"
            
        }
    }
    
    private func kullaniciBilgileri() {
        guard let uid = Auth.auth().currentUser?.uid else { return}
        self.kullaniciId = uid
        
        let userData = [ "ad": self.ad, "email": self.email, "okulNumarasi": self.okulNumarasi, "soyad": self.soyad, "uid": self.kullaniciId, "sifre": self.sifre]
        Firestore.firestore().collection("users")
            .document(uid).setData(userData)
        
    }
    
}

/*
struct kullaniciData: Codable {
    let ad: String
    let soyad: String
    let okulNumarasi: String
    let email: String
}

func kullaniciKayit(ad: String, soyad: String, okulNumarasi: String, email: String, sifre: String) {
    Auth.auth().createUser(withEmail: email, password: sifre) { result, error in
        if let kullanici = result?.user {
            let kullaniciData = kullaniciData(ad: ad, soyad: soyad, okulNumarasi: okulNumarasi, email: email)
            Firestore.firestore().collection("users").document(kullanici.uid).setData([
                "ad": ad,
                "soyad": soyad,
                "okulNumarasi": okulNumarasi,
                "email": email
            ]) { error in
                if let error = error {
                    print("Veri kaydetme hatası: \(error)")
                } else {
                    print("Veri başarıyla kaydedildi.")
                }
            }
        } else if let error = error {
            print("Kayıt hatası: \(error)")
        }
    }
}
*/
    #Preview {
        KayitEkraniView()
    }
