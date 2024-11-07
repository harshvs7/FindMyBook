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
        let vc = HomeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }


}

