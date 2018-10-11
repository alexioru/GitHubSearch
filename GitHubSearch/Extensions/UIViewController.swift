//
//  UIViewController.swift
//  GitHubSearch
//
//  Created by Alexey Rodionov on 10/11/18.
//  Copyright © 2018 Alexey Rodionov. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
