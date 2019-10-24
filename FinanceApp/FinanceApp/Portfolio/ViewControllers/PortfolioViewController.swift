//
//  PortfolioViewController.swift
//  FinanceApp
//
//  Created by Florian Marcu on 3/20/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class PortfolioViewController: ATCGenericCollectionViewController {
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
        let chartViewModel = FinanceStaticDataProvider.porfolioChart

        // Configuring the Stocks Card
        let stocksVC = StocksPreviewViewController(dsProvider: dsProvider, uiConfig: uiConfig)
        let stocksVCModel = ATCViewControllerContainerViewModel(viewController: stocksVC,
                                                                subcellHeight: 75)
        stocksVCModel.parentViewController = self

        // Configuring the Crypto Card
        let cryptosVC = CryptoPreviewViewController(dsProvider: dsProvider, uiConfig: uiConfig)
        let cryptosVCModel = ATCViewControllerContainerViewModel(viewController: cryptosVC,
                                                                 subcellHeight: 75)
        cryptosVCModel.parentViewController = self

        // Configuring the News Card
        let newsVC = NewsPreviewStoriesViewController(dsProvider: dsProvider, uiConfig: uiConfig)
        let newsVCModel = ATCViewControllerContainerViewModel(viewController: newsVC,
                                                              subcellHeight: 100)
        newsVCModel.parentViewController = self


        self.genericDataSource = ATCGenericLocalHeteroDataSource(items: [chartViewModel,
                                                                         stocksVCModel,
                                                                         cryptosVCModel,
                                                                         newsVCModel
                                                                         ])
        self.use(adapter: ATCCardViewControllerContainerRowAdapter(), for: "ATCViewControllerContainerViewModel")
        self.use(adapter: PortfolioPieChartRowAdapter(uiConfig: uiConfig), for: "ATCPieChart")
        //        self.use(adapter: ATCDividerRowAdapter(titleFont: uiConfig.regularFont(size: 16), minHeight: 30), for: "ATCDivider")

        self.title = "Portfolio"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
