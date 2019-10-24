//
//  ATCFirebaseSocialGraphManager.swift
//  ChatApp
//
//  Created by Florian Marcu on 9/15/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import FirebaseFirestore

class ATCFirebaseSocialGraphManager {
    static func fetchFriends(user: ATCUser, completion: @escaping (_ friends: [ATCUser]) -> Void) {
        guard let uid = user.uid else { return }
        let ref = Firestore.firestore().collection("friendships").whereField("user1", isEqualTo: uid)
        let usersRef = Firestore.firestore().collection("users")
        ref.getDocuments { (querySnapshot, error) in
            if let error = error {
                return
            }
            guard let querySnapshot = querySnapshot else {
                return
            }
            var friends: [ATCUser] = []
            let documents = querySnapshot.documents
            if documents.count == 0 {
                completion([])
                return
            }
            for document in documents {
                let data = document.data()
                if let user2 = data["user2"] as? String {
                    usersRef.document(user2).getDocument(completion: { (document, error) in
                        if let userDict = document?.data() {
                            let friend = ATCUser(representation: userDict)
                            friends.append(friend)
                            if friends.count == documents.count {
                                completion(friends)
                            }
                        }
                    })
                }
            }
        }
    }

    static func fetchUsers(viewer: ATCUser, completion: @escaping (_ friends: [ATCUser]) -> Void) {
        let usersRef = Firestore.firestore().collection("users")
        usersRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                return
            }
            guard let querySnapshot = querySnapshot else {
                return
            }
            var users: [ATCUser] = []
            let documents = querySnapshot.documents
            for document in documents {
                let data = document.data()
                let user = ATCUser(representation: data)
                if user.uid != viewer.uid {
                    users.append(user)
                }
            }
            completion(users)
        }
    }

    static func fetchUser(userID: String, completion: @escaping (_ user: ATCUser?) -> Void) {
        let usersRef = Firestore.firestore().collection("users").whereField("userID", isEqualTo: userID)
        usersRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                return
            }
            guard let querySnapshot = querySnapshot else {
                return
            }
            if let document = querySnapshot.documents.first {
                let data = document.data()
                let user = ATCUser(representation: data)
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
}
