//
//  ExpenseCategoriesViewController.swift
//  FinanceApp
//
//  Created by Florian Marcu on 3/18/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit
import CleverTapSDK

class ExpenseCategoriesViewController: ATCGenericCollectionViewController {
    let uiConfig: ATCUIGenericConfigurationProtocol
    let dsProvider: FinanceDataSourceProvider

    init(uiConfig: ATCUIGenericConfigurationProtocol,
         categoriesDataSource: ATCGenericCollectionViewControllerDataSource,
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

        self.genericDataSource = categoriesDataSource
        self.use(adapter: CardHeaderRowAdapter(uiConfig: uiConfig), for: "CardHeaderModel")
        self.use(adapter: CardFooterRowAdapter(uiConfig: uiConfig), for: "CardFooterModel")
        self.use(adapter: ExpenseCategoryRowAdapter(uiConfig: uiConfig), for: "ATCExpenseCategory")

        self.selectionBlock = {[weak self] (navController, object, indexPath) in
            guard let strongSelf = self else { return }
            if object is CardFooterModel {
                let vc = ExpenseCategoriesViewController(uiConfig: strongSelf.uiConfig,
                                                         categoriesDataSource: strongSelf.dsProvider.allExpenseCategoriesDataSource,
                                                         dsProvider: strongSelf.dsProvider)
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            } else if let category = object as? ATCExpenseCategory {
                let vc = TransactionsViewController(transactionDataSource: strongSelf.dsProvider.transactionsDataSource(category: category),
                                                    dsProvider: strongSelf.dsProvider,
                                                    scrollingEnabled: true,
                                                    uiConfig: strongSelf.uiConfig)
                vc.title = category.title
                strongSelf.navigationController?.pushViewController(vc, animated: true)
                let props = [
                    "Page viewed": category.title
                ]
                CleverTap.sharedInstance()?.recordEvent("Expense Viewed",withProps: props)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
