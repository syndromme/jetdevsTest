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
    
    private var router: AccountRouter?
    var viewModel: AccountViewModel?
    
	override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        router = AccountRouter(navigationController: self.navigationController!, viewController: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindUser()
    }
    
    private func bindUser() {
        let isLoggedIn = viewModel != nil
        nonLoginView.isHidden = isLoggedIn
        loginView.isHidden = !isLoggedIn
        if isLoggedIn {
            nameLabel.text = (viewModel?.user.userName ?? "")
            let date = viewModel?.user.createdAt.toDate() ?? Date()
            daysLabel.text = "Created \( date.timeAgoDisplay() )"
            headImageView.kf.setImage(with: viewModel?.user.userProfileUrl, placeholder: UIImage(named: "Avatar"))
        }
    }
	
	@IBAction func loginButtonTap(_ sender: UIButton) {
        self.router?.routeToLogin()
	}
    
    @IBAction func logoutButtonTap(_ sender: Any) {
        viewModel = nil
        bindUser()
    }
    
}
