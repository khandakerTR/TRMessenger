//
//  FCollectionReference.swift
//  TRMessenger
//
//  Created by Tushar Khandaker on 31/7/23.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Recent
}

func FirebaseReference(_ collectionReference: FCollectionReference)-> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}
