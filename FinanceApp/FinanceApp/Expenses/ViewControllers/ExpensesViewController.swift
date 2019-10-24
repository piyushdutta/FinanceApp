//
//  ExpensesViewController.swift
//  
//
//  Created by Florian Marcu on 3/17/19.
//

import Charts
import UIKit

class ExpensesViewController: ATCGenericCollectionViewController {
    let uiConfig: ATCUIGenericConfigurationProtocol
    let dsProvider: FinanceDataSourceProvider

    init(uiConfig: ATCUIGenericConfigurationProtocol,
         dsProvider: FinanceDataSourceProvider) {
        self.uiConfig = uiConfig
        self.dsProvider = dsProvider
        let layout = ATCLiquidCollectionViewLayout(cellPadding: 10)
        let homeConfig = ATCGenericCollectionViewControllerConfiguration(pullToRefreshEnabled: false,
                                                                         pullToRefreshTintColor: .white,
                                                                         collectionViewBackgroundColor: UIColor(hexString: "#f4f6f9"),
                                                                         collectionViewLayout: layout,
                                                                         collectionPagingEnabled: false,
                                                                         hideScrollIndicators: true,
                                                                         hidesNavigationBar: false,
                                                                         headerNibName: nil,
                                                                         scrollEnabled: true,
                                                                         uiConfig: uiConfig)
        super.init(configuration: homeConfig)

        // Configuring the Chart
        let chartViewModel = FinanceStaticDataProvider.expensesChart

        // Configuring categories
        let categoriesVC = ExpenseCategoriesViewController(uiConfig: uiConfig,
                                                           categoriesDataSource: dsProvider.expenseCategoriesDataSource,
                                                           dsProvider: dsProvider)
        let categoriesListModel = ATCViewControllerContainerViewModel(viewController: categoriesVC,
                                                                      subcellHeight: 67)
        categoriesListModel.parentViewController = self
        self.genericDataSource = ATCGenericLocalHeteroDataSource(items: [chartViewModel,
                                                                         categoriesListModel
                                                                         ])
        self.use(adapter: ATCCardViewControllerContainerRowAdapter(), for: "ATCViewControllerContainerViewModel")
        self.use(adapter: ExpensesPieChartRowAdapter(uiConfig: uiConfig), for: "ATCPieChart")
        //        self.use(adapter: ATCDividerRowAdapter(titleFont: uiConfig.regularFont(size: 16), minHeight: 30), for: "ATCDivider")

        self.title = "Expenses"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
