//
//  ATCWebViewController.swift
//  ATC Core
//
//  Created by Florian Marcu on 1/13/18.
//  Copyright © 2018 Florian Marcu. All rights reserved.
//

import UIKit
import WebKit

class ATCWebViewController: UIViewController, WKUIDelegate {
    let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    let url: URL

    init(url: URL, title: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        self.title = title
        webView.uiDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)

        webView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.topLayoutGuide.snp.bottom)
            maker.left.right.equalTo(view)
            maker.bottom.equalTo(self.bottomLayoutGuide.snp.top)
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
