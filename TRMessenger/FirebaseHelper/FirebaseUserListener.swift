//
//  FirebaseUserListener.swift
//  TRMessenger
//
//  Created by Tushar Khandaker on 31/7/23.
//

import Foundation
import Firebase

class FirebaseUserListener {
    
    static let shared = FirebaseUserListener()
    
    // MARK: - Register
    
    func registrationUser(with email: String, and password: String, completion: @escaping (_ error: Error?)->()) {
        Auth.auth().createUser(withEmail: email, password: password) { dataResult, error in
            completion(error)
            
            if error == nil {
                dataResult?.user.sendEmailVerification { emailError in
                    
                }
                
                //create user
                if dataResult?.user != nil {
                    let user = UserModel(userID: (dataResult?.user.uid)!, userName: email, userEmail: email, userpushID: "", avatarLink: "", status: "Hello Messenger")
                    saveUserLocally(user: user)
                    self.saveUserToFireStore(with: user)
                }
            }
        }
    }
    
    func saveUserToFireStore(with user: UserModel) {
        do {
            try FirebaseReference(.User).document(user.userID).setData(from: user)
        } catch  {
            print("Error to adding user ",error.localizedDescription)
        }
    }
    
    //MARK: - Login User
    
    func loginUser(with email: String, and password: String, completion: @escaping(_ error : Error?, _ isEmailVerified: Bool)-> () ) {
     
        Auth.auth().signIn(withEmail: email, password: password) { dataResult, error in
            if error == nil && (dataResult!.user.isEmailVerified) {
                
                FirebaseUserListener.shared.downloadUserFromFirebase(userID: (dataResult?.user.uid)!, email: email)
                completion(error, true)
                
            } else {
                completion(error, false)
                print("User Email is not verified",error?.localizedDescription)
            }
        }
    }
    
    func downloadUserFromFirebase(userID: String, email: String?) {
        FirebaseReference(.User).document(userID).getDocument { documentSnapshot, error in
            
            guard let documentSnapshot = documentSnapshot else {
                print("No document")
                return
            }
            let userResult = Result {
                try? documentSnapshot.data(as: UserModel.self)
            }
            switch userResult {
            case .success(let userObj):
                if let userObject = userObj {
                    saveUserLocally(user: userObject)
                } else {
                    print("Document not exist")
                }
            case .failure(let error):
                print("Encoding user",error.localizedDescription)
            }
        }
    }
    
    //MARK: - LogOut
    
    func logOutCurrentUser(completion: @escaping (_ error: Error?)->()) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "currentUser")
            completion(nil)
        } catch {
            print("Error to logout",error.localizedDescription)
            completion(error)
        }
    }
}
