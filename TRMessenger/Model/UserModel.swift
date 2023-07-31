//
//  UserModel.swift
//  TRMessenger
//
//  Created by Tushar Khandaker on 28/7/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct UserModel: Codable, Equatable {
    
    var userID: String
    var userName: String
    var userEmail: String
    var userpushID: String
    var avatarLink: String
    var status: String
    
    static var currentUserID: String? {
        return Auth.auth().currentUser?.uid
    }
    
    static var currentUser: UserModel? {
        if Auth.auth().currentUser != nil {
            if let dict = UserDefaults.standard.data(forKey: "currentUser") {
                let decoder = JSONDecoder()
                do {
                    let object = try decoder.decode(UserModel.self, from: dict)
                    return object
                } catch {
                    print("JSON Parsing Error > ",error.localizedDescription)
                }
            }
        }
        return nil
    }
    
    static func == (lhs: UserModel, rhs: UserModel)-> Bool {
        return lhs.userID == rhs.userID
    }
}

func saveUserLocally(user: UserModel) {
    
    do {
        let data = try JSONEncoder().encode(user)
        UserDefaults.standard.set(data, forKey: "currentUser")
    } catch {
        print("Error to save error locally",error.localizedDescription)
    }
}
