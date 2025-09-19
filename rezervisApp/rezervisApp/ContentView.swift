//
//  ContentView.swift
//  rezervisApp
//
//  Created by Oktay Aydın on 7.03.2025.
//

import SwiftUI
import Firebase
import FirebaseAuth


class FirebaseManager: NSObject {
    
    let auth: Auth
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        
        super.init()
    }
}


struct ContentView: View {
    
    @State var email = ""
    @State var sifre = ""
    @State private var kullaniciTipi = "Kullanıcı"
    @State private var hataMesaji = ""
    @State private var girisYapildi = false
    @State private var yoneticiGiris = false
    @State private var kayitSayfasinaGit = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Servis Yönetim Sistemi")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Picker("Rol Seçiniz", selection: $kullaniciTipi) {
                    Text("Kullanıcı").tag("Kullanıcı")
                    Text("Yönetici").tag("Yönetici")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                TextField("E-posta", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocapitalization(.none)
                
                SecureField("Şifre", text: $sifre)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocapitalization(.none)
                
                if !hataMesaji.isEmpty {
                    Text(hataMesaji)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                
                Button(action: {
                    if (kullaniciTipi == "Yönetici" && email == "yonetici@gmail.com" && sifre == "yonetici") {
                        yoneticiGiris = true
                        email = ""
                        sifre = ""
                    }
                    else if (kullaniciTipi == "Kullanıcı") {
                        Auth.auth().signIn(withEmail: email, password: sifre) { result, error in
                            if let error = error {
                                print("Giriş başarısız: \(error.localizedDescription)")
                                girisYapildi = false
                                hataMesaji = "Giriş başarısız"
                                return
                            }

                            // Giriş başarılıysa burası çalışır
                            girisYapildi = true
                            print("Giriş başarılı: \(result?.user.email ?? "")")
                            // Burada yönlendirme işlemini yaparsın
                        }
                    }
                }) {
                    Text("Giriş Yap")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Button(action: {
                  kayitSayfasinaGit = true
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
                
                NavigationLink(
                    destination: KayitEkraniView(),
                isActive: $kayitSayfasinaGit
                ) {
                EmptyView()
                }
                
                NavigationLink(destination: YoneticiAnaEkran(), isActive: $yoneticiGiris) {
                                EmptyView()
                            }
                NavigationLink(destination: KullaniciAnaEkran(), isActive: $girisYapildi) {
                                EmptyView()
                            }
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
