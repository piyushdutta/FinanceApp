//
//  CardHeaderModel.swift
//  FinanceApp
//
//  Created by Florian Marcu on 3/16/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class CardHeaderModel: ATCGenericBaseModel {
    var title: String

    required init(jsonDict: [String: Any]) {
        fatalError()
    }

    init(title: String) {
        self.title = title
    }

    var description: String {
        return title
    }
}
