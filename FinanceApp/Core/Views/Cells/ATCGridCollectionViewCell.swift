//
//  ATCGridCollectionViewCell.swift
//  ListingApp
//
//  Created by Florian Marcu on 6/9/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit

class ATCGridCollectionViewCell: UICollectionViewCell {
    @IBOutlet var gridTitleLabel: UILabel!
    @IBOutlet var gridView: UIView!
    @IBOutlet var callToActionButton: UIButton!

    private var viewModel: ATCGridViewModel?

    func configure(viewModel: ATCGridViewModel, uiConfig: ATCUIGenericConfigurationProtocol) {
        self.viewModel = viewModel

        gridTitleLabel.isHidden = (viewModel.title == nil)
        gridTitleLabel.text = viewModel.title
        gridTitleLabel.font = uiConfig.boldLargeFont
        gridTitleLabel.textColor = uiConfig.mainTextColor
        callToActionButton.configure(color: uiConfig.mainThemeForegroundColor,
                                     font: uiConfig.mediumBoldFont)
        callToActionButton.setTitle(viewModel.callToAction, for: .normal)
        callToActionButton.addTarget(self, action: #selector(didTapCallToActionButton) , for: .touchUpInside)

        gridView.setNeedsLayout()
        gridView.layoutIfNeeded()

        let viewController = viewModel.viewController

        viewController.view.frame = gridView.bounds
        gridView.addSubview(viewController.view)
        self.setNeedsLayout()
        viewModel.parentViewController?.addChild(viewModel.viewController)
    }

    @objc func didTapCallToActionButton() {
        if let block = viewModel?.callToActionBlock {
            block()
        }
    }
}
