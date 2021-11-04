//
//  AccountViewController.swift
//  JetDevsHomeWork
//
//  Created by Gary.yao on 2021/10/29.
//

import UIKit
import Kingfisher

class AccountViewController: UIViewController {

	@IBOutlet weak var nonLoginView: UIView!
	@IBOutlet weak var loginView: UIView!
	@IBOutlet weak var daysLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var headImageView: UIImageView!
	override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
		nonLoginView.isHidden = false
		loginView.isHidden = true
    }
	
	@IBAction func loginButtonTap(_ sender: UIButton) {
	}
	
}
