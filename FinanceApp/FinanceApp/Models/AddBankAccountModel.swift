//
//  AddBankAccountModel.swift
//  FinanceApp
//
//  Created by Florian Marcu on 3/25/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class AddBankAccountModel: ATCGenericBaseModel {
    required init(jsonDict: [String: Any]) {
        fatalError()
    }

    init() {}

    var description: String {
        return "bank account button"
    }
}
