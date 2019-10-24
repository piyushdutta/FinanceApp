//
//  ATCImage.swift
//  ListingApp
//
//  Created by Florian Marcu on 6/10/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

class ATCImage: ATCGenericBaseModel {

    var urlString: String?
    var localImage: UIImage? = nil
    var isActionable: Bool = false

    convenience init(_ urlString: String? = nil) {
        self.init(jsonDict: [:])
        self.urlString = urlString
    }

    convenience init(localImage: UIImage) {
        self.init(jsonDict: [:])
        self.localImage = localImage
        self.urlString = nil
    }

    required init(jsonDict: [String: Any]) {}

    var description: String {
        return urlString ?? ""
    }
}
