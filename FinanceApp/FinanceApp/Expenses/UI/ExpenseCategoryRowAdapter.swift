//
//  ExpenseCategoryRowAdapter.swift
//  FinanceApp
//
//  Created by Florian Marcu on 3/18/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class ExpenseCategoryRowAdapter: ATCGenericCollectionRowAdapter {
    var uiConfig: ATCUIGenericConfigurationProtocol
    init(uiConfig: ATCUIGenericConfigurationProtocol) {
        self.uiConfig = uiConfig
    }

    func configure(cell: UICollectionViewCell, with object: ATCGenericBaseModel) {
        if let category = object as? ATCExpenseCategory, let cell = cell as? ExpenseCategoryCollectionViewCell {
            cell.categoryImageView.kf.setImage(with: URL(string: category.logoURL))
            cell.categoryImageView.contentMode = .scaleAspectFill
            cell.categoryImageView.tintColor = .white
            cell.categoryImageView.backgroundColor = UIColor(hexString: category.color)
            cell.categoryImageView.layer.cornerRadius = 40 / 2
            cell.categoryImageView.clipsToBounds = true

            cell.categoryTitleLabel.text = category.title.uppercased()
            cell.categoryTitleLabel.textColor = uiConfig.mainSubtextColor
            cell.categoryTitleLabel.font = uiConfig.boldFont(size: 14)

            cell.categorySpendingLabel.text = category.spending
            cell.categorySpendingLabel.textColor = uiConfig.mainTextColor
            cell.categorySpendingLabel.font = uiConfig.regularFont(size: 18)

            cell.arrowImageView.image = UIImage.localImage("forward-arrow-black", template: true)
            cell.arrowImageView.tintColor = uiConfig.mainSubtextColor

            cell.bottomBorderView.backgroundColor = uiConfig.hairlineColor
            cell.backgroundColor = uiConfig.mainThemeBackgroundColor
            cell.containerView.backgroundColor = .clear
        }
    }

    func cellClass() -> UICollectionViewCell.Type {
        return ExpenseCategoryCollectionViewCell.self
    }

    func size(containerBounds: CGRect, object: ATCGenericBaseModel) -> CGSize {
        guard let viewModel = object as? ATCExpenseCategory else { return .zero }
        return CGSize(width: containerBounds.width, height: 70)
    }
}
