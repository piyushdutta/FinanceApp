//
//  ATCProfileUpdaterProtocol.swift
//  DatingApp
//
//  Created by Florian Marcu on 2/2/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

protocol ATCProfileUpdaterProtocol: class {
    func removePhoto(url: String, user: ATCUser, completion: @escaping () -> Void)
    func uploadPhoto(image: UIImage, user: ATCUser, isProfilePhoto: Bool, completion: @escaping () -> Void)
    func update(user: ATCUser, email: String, firstName: String, lastName: String, username: String, completion: @escaping (_ success: Bool) -> Void)
}
