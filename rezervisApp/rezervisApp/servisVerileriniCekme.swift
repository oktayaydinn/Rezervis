//
//  servisVerileriniCekme.swift
//  rezervisApp
//
//  Created by Oktay Aydın on 23.03.2025.
//

import Foundation
import Firebase

class veriModeli: ObservableObject{
    @Published var servisListesi = [Servis]()

    func veriAlma() {
        let database=Firestore.firestore()
        
        database.collection("services").getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.servisListesi = snapshot.documents.map({ veriler in
                            return Servis(id: veriler.documentID, kalkisYeri: veriler["kalkisYeri"] as? String ?? "", varisyeri: veriler["varisYeri"] as? String ?? "", tarih: veriler["tarih"] as? String ?? "", kalkisSaati: veriler["saat"] as? String ?? "", koltukSayisi: veriler["koltukSayisi"] as? Int ?? 0)
                        })
                    }
                }
            }
            else{
                
            }
        }
    }
}
