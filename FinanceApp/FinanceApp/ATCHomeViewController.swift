//
//  ATCHomeViewController.swift
//  FinanceApp
//
//  Created by Florian Marcu on 3/10/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import Charts
import UIKit
import CleverTapSDK

class ATCHomeViewController: ATCGenericCollectionViewController {
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
        let dateList: ATCDateList = ATCDateList(dates: [
            ATCChartDate(title: "1D", startDate: Date().yesterday),
            ATCChartDate(title: "1W", startDate: Date().oneWeekAgo),
            ATCChartDate(title: "1M", startDate: Date().oneMonthAgo),
            ATCChartDate(title: "3M", startDate: Date().threeMonthsAgo),
            ATCChartDate(title: "1Y", startDate: Date().oneYearAgo),
            ATCChartDate(title: "All", startDate: Date().infiniteAgo)
            ])

        let lineChartViewController = ATCDatedLineChartViewController(dateList: dateList,
                                                                      uiConfig: uiConfig)
        lineChartViewController.delegate = self

        let chartViewModel = ATCViewControllerContainerViewModel(viewController: lineChartViewController,
                                                                 cellHeight: 300,
                                                                 subcellHeight: nil)
        chartViewModel.parentViewController = self

        // Configuring cash
        let cashVC = CashViewController(uiConfig: uiConfig,
                                        dsProvider: dsProvider)
        let cashListModel = ATCViewControllerContainerViewModel(viewController: cashVC,
                                                                subcellHeight: 67)
        cashListModel.parentViewController = self

        // Configuring investments
        let investmentsVC = InvestmentsViewController(uiConfig: uiConfig,
                                                      dsProvider: dsProvider)
        let investmentsListModel = ATCViewControllerContainerViewModel(viewController: investmentsVC,
                                                                       subcellHeight: 67)
        investmentsListModel.parentViewController = self

        // Configuring liabilities
        let liabilitiesVC = LiabilitiesViewController(uiConfig: uiConfig,
                                                      dsProvider: dsProvider)
        let liabilitiesListModel = ATCViewControllerContainerViewModel(viewController: liabilitiesVC,
                                                                       subcellHeight: 67)
        liabilitiesListModel.parentViewController = self

        self.genericDataSource = ATCGenericLocalHeteroDataSource(items: [chartViewModel,
                                                                         cashListModel,
                                                                         investmentsListModel,
                                                                         liabilitiesListModel])
        self.use(adapter: ATCCardViewControllerContainerRowAdapter(), for: "ATCViewControllerContainerViewModel")
        //        self.use(adapter: ATCDividerRowAdapter(titleFont: uiConfig.regularFont(size: 16), minHeight: 30), for: "ATCDivider")

        self.title = "Home"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func lineChartData(chart: ATCLineChart, config: ATCLineChartConfiguration) -> LineChartData {
        var lineChartEntry = [ChartDataEntry]()
        for (index, number) in chart.numbers.enumerated() {
            let value = ChartDataEntry(x: Double(index), y: number)
            lineChartEntry.append(value)
        }
        let line1 = LineChartDataSet(entries: lineChartEntry, label: nil)
        line1.colors = [config.lineColor]
        line1.lineWidth = 3
        line1.drawValuesEnabled = false
        line1.mode = .cubicBezier
        line1.circleRadius = 0
        line1.circleHoleRadius = 4
        line1.drawFilledEnabled = true
        let colors: CFArray = [config.gradientStartColor.cgColor, config.gradientEndColor.cgColor] as CFArray
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: [1.0, 0.0])
        let fill = Fill(linearGradient: gradient!, angle: 90.0)

        line1.fill = fill
        let data = LineChartData()
        data.addDataSet(line1)
        return data
    }
}

extension ATCHomeViewController: ATCDatedLineChartViewControllerDelegate {
    func datedLineChartViewController(_ viewController: ATCDatedLineChartViewController,
                                      didSelect chartDate: ATCChartDate,
                                      titleLabel: UILabel,
                                      chartView: LineChartView ) -> Void {
        dsProvider.fetchLineChart(for: chartDate) {[weak self] (lineChart) in
            guard let `self` = self else { return }
            if let lineChart = lineChart {
                let config = dsProvider.chartConfig
                chartView.data = self.lineChartData(chart: lineChart, config: config)
                chartView.backgroundColor = config.backgroundColor
                chartView.chartDescription?.enabled = true

                chartView.pinchZoomEnabled = false
                chartView.dragEnabled = false
                chartView.setScaleEnabled(false)
                chartView.legend.enabled = false
                chartView.xAxis.enabled = false
                chartView.rightAxis.enabled = true
                chartView.rightAxis.drawGridLinesEnabled = false
                chartView.rightAxis.drawZeroLineEnabled = false
                chartView.rightAxis.drawAxisLineEnabled = false
                chartView.rightAxis.valueFormatter = ATCAbbreviatedAxisValueFormatter()
                chartView.rightAxis.labelTextColor = config.leftAxisColor
                chartView.leftAxis.enabled = false

                titleLabel.text = FinanceStaticDataProvider.currencyString + String(Int(lineChart.numbers.last ?? 0.0))
                titleLabel.font = uiConfig.regularFont(size: 30)
                titleLabel.textColor = uiConfig.mainTextColor
                //                chartView.leftAxis.labelTextColor = config.leftAxisColor
                //                chartView.leftAxis.axisLineColor = config.leftAxisColor
                //                chartView.leftAxis.valueFormatter = ATCAbbreviatedAxisValueFormatter()

                //                chartView.chartDescription?.text = lineChart.name
                //                chartView.chartDescription?.font = config.descriptionFont
                //                chartView.chartDescription?.textColor = config.descriptionColor
            } else {
                chartView.data = nil
            }
        }
    }
}
