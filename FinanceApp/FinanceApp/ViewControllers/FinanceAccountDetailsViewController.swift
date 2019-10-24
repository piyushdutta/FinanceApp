//
//  FinanceProfileViewController.swift
//  FinanceApp
//
//  Created by Florian Marcu on 3/24/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import Eureka
import UIKit

class FinanceAccountDetailsViewController: FormViewController {
    var user: ATCUser
    var updater: ATCProfileUpdaterProtocol

    init(user: ATCUser,
         updater: ATCProfileUpdaterProtocol) {
        self.user = user
        self.updater = updater
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapDone))
        //        if (cancelEnabled) {
        //            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        //        }
        self.title = "Settings"
        form +++ Section("Public Profile")
            <<< TextRow(){ row in
                row.title = "First Name"
                row.placeholder = "Your first name"
                row.value = user.firstName
                row.tag = "firstname"
            }
            <<< TextRow(){ row in
                row.title = "Last Name"
                row.placeholder = "Your last name"
                row.value = user.lastName
                row.tag = "lastname"
            }
            <<< TextRow(){ row in
                row.title = "Username"
                row.placeholder = "Your first name"
                row.value = user.username
                row.tag = "username"
            }
            <<< ActionSheetRow<String>() {
                $0.title = "Gender"
                $0.selectorTitle = "Choose your gender"
                $0.options = ["Not selected", "Female", "Male"]
                    $0.value = ""
                    $0.tag = "gender"
            }
            +++ Section("Private Details")
            <<< TextRow(){ row in
                row.title = "E-mail Address"
                row.placeholder = "Your e-mail address"
                row.value = user.email
                row.tag = "email"
        }
    }

    @objc private func didTapDone() {
        var lastName = ""
        var firstName = ""
        var email = ""
        var username = ""
        var gender = ""

        if let row = form.rowBy(tag: "lastname") as? TextRow {
            lastName = row.value ?? ""
        }
        if let row = form.rowBy(tag: "firstname") as? TextRow {
            firstName = row.value ?? ""
        }
        if let row = form.rowBy(tag: "email") as? TextRow {
            email = row.value ?? ""
        }
        if let row = form.rowBy(tag: "username") as? TextRow {
            username = row.value ?? ""
        }
        if let row = form.rowBy(tag: "gender") as? ActionSheetRow<String> {
            gender = row.value ?? ""
        }
        if  email == "" || firstName == "" || gender == "" {
            let alertVC = UIAlertController(title: "Please complete your profile",
                                            message: "Fill out all the blank fields",
                                            preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
            return
        }
        self.updater.update(user: user, email: email, firstName: firstName, lastName: lastName, username: username) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    @objc private func didTapCancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
