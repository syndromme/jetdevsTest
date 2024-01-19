//
//  AccountViewController.swift
//  JetDevsHomeWork
//
//  Created by Gary.yao on 2021/10/29.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class AccountViewController: UIViewController {
    
    private let disposeBag = DisposeBag()

	@IBOutlet weak var nonLoginView: UIView!
	@IBOutlet weak var loginView: UIView!
	@IBOutlet weak var daysLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    private var router: AccountRouter?
    var viewModel: AccountViewModel?
    
	override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        router = AccountRouter(navigationController: self.navigationController!, viewController: self)
        
        bindViewModel()
    }
    
// MARK: - ViewModel
    private func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let input = AccountViewModel.Input(trigger: viewWillAppear, loginTrigger: loginButton.rx.tap.asDriver(), logoutTrigger: logoutButton.rx.tap.asDriver())
        viewModel = AccountViewModel(router: router!, input: input)
        viewModel?.errorTracker.drive(errorResponse).disposed(by: disposeBag)
        viewModel?.activityIndicator.drive(progressBinding).disposed(by: disposeBag)
        viewModel?.currentUser.drive(bindUser).disposed(by: disposeBag)
        viewModel?.logout.drive(onNext: { _ in
            self.bindCurrentUser(user: nil)
        }).disposed(by: disposeBag)
    }
    
// MARK: - Binder
    var bindUser: Binder<UserModel?> {
        return Binder(self, binding: {( _, user) in
            self.bindCurrentUser(user: user)
        })
    }
    
// MARK: - Custom
    func bindCurrentUser(user: UserModel?) {
        let isLoggedIn = user != nil
        nonLoginView.isHidden = isLoggedIn
        loginView.isHidden = !isLoggedIn
        if isLoggedIn {
            nameLabel.text = (user?.userName ?? "")
            let date = user?.createdAt.toDate() ?? Date()
            daysLabel.text = "Created \( date.timeAgoDisplay() )"
            headImageView.kf.setImage(with: user?.userProfileUrl, placeholder: UIImage(named: "Avatar"))
        }
    }
}
