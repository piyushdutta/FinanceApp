//
//  ATCProfileViewController.swift
//  DatingApp
//
//  Created by Florian Marcu on 2/2/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import UIKit

class ATCProfileViewController: ATCGenericCollectionViewController {

    var user: ATCUser? {
        didSet {
            update()
        }
    }
    var uiConfig: ATCUIGenericConfigurationProtocol
    var items: [ATCGenericBaseModel]

    init(items: [ATCGenericBaseModel],
         uiConfig: ATCUIGenericConfigurationProtocol,
         selectionBlock: ATCollectionViewSelectionBlock? = nil) {
        let profileVCConfig = ATCGenericCollectionViewControllerConfiguration(
            pullToRefreshEnabled: false,
            pullToRefreshTintColor: .white,
            collectionViewBackgroundColor: .white,
            collectionViewLayout: ATCCollectionViewFlowLayout(),
            collectionPagingEnabled: false,
            hideScrollIndicators: false,
            hidesNavigationBar: false,
            headerNibName: nil,
            scrollEnabled: true,
            uiConfig: uiConfig
        )
        self.items = items
        self.uiConfig = uiConfig
        super.init(configuration: profileVCConfig, selectionBlock: selectionBlock)
        self.use(adapter: ATCProfileItemRowAdapter(uiConfig: uiConfig), for: "ATCProfileItem")
        self.use(adapter: ATCTextRowAdapter(font: uiConfig.boldFont(size: 18),
                                            textColor: UIColor(hexString: "#4A4A4A"),
                                            alignment: .center),
                 for: "ATCText")
        self.use(adapter: ATCImageRowAdapter(cellHeight: 160, contentMode: .scaleAspectFill), for: "ATCImage")
        self.use(adapter: ATCDividerRowAdapter(titleFont: uiConfig.regularFont(size: 16), minHeight: 10), for: "ATCDivider")
        self.use(adapter: ATCProfileButtonItemRowAdapter(uiConfig: uiConfig), for: "ATCProfileButtonItem")
        self.update()
    }

    fileprivate func update() {
        var allItems: [ATCGenericBaseModel] = []
        if let user = user {
            allItems.append(ATCImage(user.profilePictureURL))
            allItems.append(ATCText(text: user.fullName()))
        }
        allItems.append(contentsOf: self.items)
        allItems.append(ATCProfileButtonItem(title: "Logout"))
        self.genericDataSource = ATCGenericLocalHeteroDataSource(items: allItems)
        self.genericDataSource?.loadFirst()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
