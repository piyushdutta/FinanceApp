//
//  ATCNavigationController.swift
//  AppTemplatesFoundation
//
//  Created by Florian Marcu on 2/11/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import UIKit
import CleverTapSDK

public protocol ATCNavigationControllerDelegate: class {
    func navigationControllerDidTapMenuButton(_ navigationController: ATCNavigationController)
}

public class ATCNavigationController: UINavigationController, UINavigationControllerDelegate {
    fileprivate var menuButton: UIBarButtonItem?
    fileprivate var topNavigationRightViews: [UIView]?
    fileprivate var titleView: UIView?
    var topNavigationLeftViews: [UIView]?
    fileprivate var topNavigationLeftImage: UIImage?
    weak var drawerDelegate: ATCNavigationControllerDelegate?

    public init(rootViewController: UIViewController,
                topNavigationLeftViews: [UIView]? = nil,
                topNavigationRightViews: [UIView]?,
                titleView: UIView? = nil,
                topNavigationLeftImage: UIImage?,
                topNavigationTintColor: UIColor? = .white) {
        super.init(rootViewController: rootViewController)
        self.topNavigationLeftViews = topNavigationLeftViews
        self.topNavigationRightViews = topNavigationRightViews
        self.titleView = titleView
        self.topNavigationLeftImage = topNavigationLeftImage
        if let topNavigationLeftImage = topNavigationLeftImage {
            let imageButton = UIButton()
            imageButton.setImage(topNavigationLeftImage, for: .normal)
            if let topNavigationTintColor = topNavigationTintColor {
                imageButton.tintColor = topNavigationTintColor
            }
            imageButton.addTarget(self, action: #selector(handleMenuButton), for: .touchUpInside)
            menuButton = UIBarButtonItem(customView: imageButton)
            imageButton.snp.makeConstraints({ (maker) in
                maker.width.equalTo(25)
                maker.height.equalTo(25)
            })
        }
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.view.backgroundColor = .white
    }

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        print("test controller name:", NSStringFromClass(viewController.classForCoder))
        
        if (NSStringFromClass(viewController.classForCoder) == "FinanceApp.PortfolioViewController") {
            CleverTap.sharedInstance()?.recordEvent("Portfolio Viewed")
        } else if (NSStringFromClass(viewController.classForCoder) == "FinanceApp.ExpensesViewController") {
            CleverTap.sharedInstance()?.recordEvent("Expenses Viewed")
        } else if (NSStringFromClass(viewController.classForCoder) == "FinanceApp.BankAccountsViewController") {
            CleverTap.sharedInstance()?.recordEvent("Bank Viewed")
        } else if (NSStringFromClass(viewController.classForCoder) == "FinanceApp.ATCHomeViewController") {
            CleverTap.sharedInstance()?.recordEvent("Home Page Viewed")
        }
        
        prepareNavigationBar()
    }
}

extension ATCNavigationController {
    func prepareNavigationBar() {
        topViewController?.navigationItem.title = topViewController?.title
        if self.viewControllers.count <= 1 {
            if let titleView = titleView {
                topViewController?.navigationItem.titleView = titleView
            }
            if let topNavigationRightViews = topNavigationRightViews {
                topViewController?.navigationItem.rightBarButtonItems = topNavigationRightViews.map{UIBarButtonItem(customView: $0)}
            }
            if let topNavigationLeftViews = topNavigationLeftViews {
                topViewController?.navigationItem.leftBarButtonItems = topNavigationLeftViews.map{UIBarButtonItem(customView: $0)}
            } else {
                if let menuButton = menuButton {
                    topViewController?.navigationItem.leftBarButtonItem = menuButton
                }
            }
        }
    }
}

extension ATCNavigationController {
    @objc
    fileprivate func handleMenuButton() {
        drawerDelegate?.navigationControllerDidTapMenuButton(self)
    }
}
