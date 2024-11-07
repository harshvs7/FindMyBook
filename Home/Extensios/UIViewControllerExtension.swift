//
//  UIViewControllerExtension.swift
//  FindMyBook
//
//  Created by Harshvardhan Sharma on 07/11/24.
//

import UIKit

//MARK: For common functions across the App
extension UIViewController {
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
