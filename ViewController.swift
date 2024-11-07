//
//  ViewController.swift
//  FindMyBook
//
//  Created by Harshvardhan Sharma on 07/11/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let vc = HomeViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }


}

