//
//  ExpensesPieChartRowAdapter.swift
//  FinanceApp
//
//  Created by Florian Marcu on 3/17/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import Charts
import UIKit

class ExpensesPieChartRowAdapter: ATCGenericCollectionRowAdapter, ChartViewDelegate {

    let uiConfig: ATCUIGenericConfigurationProtocol

    init(uiConfig: ATCUIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
    }

    func configure(cell: UICollectionViewCell, with object: ATCGenericBaseModel) {
        if let pieChart = object as? ATCPieChart,
            let cell = cell as? ATCPieChartCollectionViewCell,
            let chartView = cell.pieChartView {

            let dataSet = PieChartDataSet(entries: pieChart.entries, label: pieChart.name)
            let data = PieChartData(dataSet: dataSet)
            chartView.data = data

            dataSet.colors = [NSUIColor(hexString: "#ff8e9c"),
                              NSUIColor(hexString: "#229ff6"),
                              NSUIColor(hexString: "#9ed764"),
                              NSUIColor(hexString: "#ffd38d"),
                              NSUIColor(hexString: "#ff8711"),
            ]
            dataSet.valueFormatter = MyFormatter(format: pieChart.format)

            chartView.backgroundColor = uiConfig.mainThemeBackgroundColor
            chartView.drawHoleEnabled = true
            chartView.legend.textColor = uiConfig.mainTextColor
            chartView.legend.direction = .leftToRight
            chartView.legend.font = uiConfig.regularMediumFont
            chartView.legend.textColor = uiConfig.mainThemeForegroundColor
            chartView.legend.enabled = true
            chartView.legend.xOffset = 32

            chartView.setExtraOffsets(left: -10, top: -10, right: -10, bottom: -15)
            chartView.notifyDataSetChanged()
            cell.setNeedsLayout()
        }
    }

    func cellClass() -> UICollectionViewCell.Type {
        return ATCPieChartCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: ATCGenericBaseModel) -> CGSize {
        guard object is ATCPieChart else { return .zero }
        return CGSize(width: containerBounds.width, height: 350)
    }

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("Asda")
    }
}
