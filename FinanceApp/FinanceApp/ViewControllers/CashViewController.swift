//
//  PortfolioCashViewController.swift
//  FinanceApp
//
//  Created by Florian Marcu on 3/20/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit
import CleverTapSDK

class CashViewController: ATCGenericCollectionViewController {
    let uiConfig: ATCUIGenericConfigurationProtocol
    let dsProvider: FinanceDataSourceProvider

    init(uiConfig: ATCUIGenericConfigurationProtocol,
         dsProvider: FinanceDataSourceProvider) {
        self.uiConfig = uiConfig
        self.dsProvider = dsProvider
        let layout = ATCLiquidCollectionViewLayout()
        let config = ATCGenericCollectionViewControllerConfiguration(pullToRefreshEnabled: false,
                                                                     pullToRefreshTintColor: .white,
                                                                     collectionViewBackgroundColor: uiConfig.mainThemeBackgroundColor,
                                                                     collectionViewLayout: layout,
                                                                     collectionPagingEnabled: false,
                                                                     hideScrollIndicators: true,
                                                                     hidesNavigationBar: false,
                                                                     headerNibName: nil,
                                                                     scrollEnabled: false,
                                                                     uiConfig: uiConfig)
        super.init(configuration: config)

        self.genericDataSource = dsProvider.portfolioCashDataSource
        self.use(adapter: CardHeaderRowAdapter(uiConfig: uiConfig), for: "CardHeaderModel")
        self.use(adapter: FinanceAccountRowAdapter(uiConfig: uiConfig), for: "ATCFinanceAccount")

        self.selectionBlock = {[weak self] (navController, object, indexPath) in
            guard let strongSelf = self else { return }
            if let account = object as? ATCFinanceAccount {
                let vc = TransactionsViewController(transactionDataSource: dsProvider.transactionsDataSource(account: account),
                                                    dsProvider: strongSelf.dsProvider,
                                                    scrollingEnabled: true,
                                                    uiConfig: strongSelf.uiConfig)
                strongSelf.navigationController?.pushViewController(vc, animated: true)
                let props = [
                    "Page Viewed": "Cash"
                ]
                CleverTap.sharedInstance()?.recordEvent("Home Page viewed", withProps: props)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
