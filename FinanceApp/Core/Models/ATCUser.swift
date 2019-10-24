//
//  ATCUser.swift
//  AppTemplatesCore
//
//  Created by Florian Marcu on 2/2/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import Foundation

open class ATCUser: NSObject, ATCGenericBaseModel, NSCoding {

    var uid: String?
    var username: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var profilePictureURL: String?
    var pushToken: String?
    var isOnline: Bool
    var photos: [String]? = nil

    public init(uid: String = "", firstName: String, lastName: String, avatarURL: String = "", email: String = "", pushToken: String? = nil, photos: [String]? = [], isOnline: Bool = false) {
        self.firstName = firstName
        self.lastName = lastName
        self.uid = uid
        self.email = email
        self.profilePictureURL = avatarURL
        self.pushToken = pushToken
        self.photos = photos
        self.isOnline = isOnline
    }

    public init(representation: [String: Any]) {
        self.firstName = representation["firstName"] as? String
        self.lastName = representation["lastName"] as? String
        self.profilePictureURL = representation["profilePictureURL"] as? String
        self.username = representation["username"] as? String
        self.email = representation["email"] as? String
        self.uid = representation["userID"] as? String
        self.pushToken = representation["fcmToken"] as? String
        self.photos = representation["photos"] as? [String]

        self.isOnline = false
    }

    required public init(jsonDict: [String: Any]) {
        fatalError()
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(profilePictureURL, forKey: "profilePictureURL")
        aCoder.encode(pushToken, forKey: "pushToken")
        aCoder.encode(isOnline, forKey: "isOnline")
        aCoder.encode(photos, forKey: "photos")
    }

    public convenience required init?(coder aDecoder: NSCoder) {
        self.init(uid: aDecoder.decodeObject(forKey: "uid") as? String ?? "unknown",
                  firstName: aDecoder.decodeObject(forKey: "firstName") as? String ?? "",
                  lastName: aDecoder.decodeObject(forKey: "lastName") as? String ?? "",
                  avatarURL: aDecoder.decodeObject(forKey: "profilePictureURL") as? String ?? "",
                  email: aDecoder.decodeObject(forKey: "email") as? String ?? "",
                  pushToken: aDecoder.decodeObject(forKey: "pushToken") as? String ?? "",
                  photos: aDecoder.decodeObject(forKey: "photos") as? [String] ?? [],
                  isOnline: aDecoder.decodeBool(forKey: "isOnline"))
    }

//    public func mapping(map: Map) {
//        username            <- map["username"]
//        email               <- map["email"]
//        firstName           <- map["first_name"]
//        lastName            <- map["last_name"]
//        profilePictureURL   <- map["profile_picture"]
//    }

    public func fullName() -> String {
        guard let firstName = firstName, let lastName = lastName else { return self.firstName ?? "" }
        return "\(firstName) \(lastName)"
    }

    public func firstWordFromName() -> String {
        if let firstName = firstName, let first = firstName.components(separatedBy: " ").first {
            return first
        }
        return "No name"
    }

    var initials: String {
        if let f = firstName?.first, let l = lastName?.first {
            return String(f) + String(l)
        }
        return "?"
    }

    var representation: [String : Any] {
        let rep: [String : Any] = [
            "userID": uid,
            "profilePictureURL": profilePictureURL ?? "",
            "username": username ?? "",
            "email": email ?? "",
            "firstName": firstName ?? "",
            "lastName": lastName ?? "",
            "pushToken": pushToken ?? "",
            "photos": photos ?? "",
            ]
        return rep
    }
}
