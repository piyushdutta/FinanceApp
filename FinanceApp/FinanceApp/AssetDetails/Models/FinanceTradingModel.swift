//
//  FinanceTradingModel.swift
//  FinanceApp
//
//  Created by Florian Marcu on 3/23/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class FinanceTradingModel: ATCGenericBaseModel {

    required init(jsonDict: [String: Any]) {
        fatalError()
    }

    init() {
    }

    var description: String {
        return "trading"
    }
}
