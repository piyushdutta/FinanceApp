//
//  ATCProfileButtonItem.swift
//  DatingApp
//
//  Created by Florian Marcu on 2/2/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class ATCProfileButtonItem: ATCGenericBaseModel {
    var title: String

    init(title: String) {
        self.title = title
    }

    required public init(jsonDict: [String: Any]) {
        fatalError()
    }

    public var description: String {
        return title
    }
}
