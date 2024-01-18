//
//  FloatingTextField.swift
//  JetDevsHomeWork
//
//  Created by syndromme on 09/01/24.
//

import UIKit
import RxSwift
import RxCocoa

let animationDuration = 1.0

class FloatingTextField: UIView {
    
    @IBOutlet private weak var floatingLabel: UILabel!
    @IBOutlet private weak var inputField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    
    @IBInspectable var placeholder: String = ""
    @IBInspectable var attributedPlaceholder: NSAttributedString?
    @IBInspectable var inputFont: UIFont?
    @IBInspectable var inputColor: UIColor?
    @IBInspectable var isSecure: Bool = false
    @IBInspectable var floatingText: String = ""
    @IBInspectable var floatingFont: UIFont?
    @IBInspectable var floatingColor: UIColor?
    @IBInspectable var radius: CGFloat = 5
    @IBInspectable var borderColor: UIColor?
    @IBInspectable var borderWidth: CGFloat = 0.5
    @IBInspectable var keyboardType: UIKeyboardType = .default
    @IBInspectable var errorFont: UIFont?
    @IBInspectable var errorColor: UIColor = .red
    
    var textField: UITextField {
        get { return inputField }
    }
    
    override func awakeFromNib() {
      super.awakeFromNib()
      setupNib()
        DispatchQueue.main.async {
            self.setupLayout()
        }
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      awakeFromNib()
    }

    override init(frame: CGRect) {
      super.init(frame: frame)
      awakeFromNib()
    }
    
    func updatePlaceholderFrame(_ isMoveUp: Bool?) {
            
        if (inputField.placeholder?.isEmpty ?? true) {
            return
        }
        
        // Move Placeholder
        if isMoveUp! {
            UIView.animate(withDuration: animationDuration) {
                self.floatingLabel.superview?.isHidden = false
            }
        } else {
            UIView.animate(withDuration: animationDuration) {
                self.floatingLabel.superview?.isHidden = true
            }
        }
    }
}

extension FloatingTextField {
    
    func setupLayout() {
        self.inputField.addTarget(self, action: #selector(textFieldDidChange(_ :)), for: .editingChanged)
        self.inputField.placeholder = placeholder
        self.inputField.isSecureTextEntry = self.isSecure
        self.inputField.keyboardType = self.keyboardType
        if let attStr = attributedPlaceholder {
            self.inputField.attributedPlaceholder = attStr
        }
        if let font = inputFont {
            self.inputField.font = font
        }
        if let font = floatingFont {
            self.floatingLabel.font = font
        }
        if let font = errorFont {
            self.errorLabel.font = font
        }
        if let color = inputColor {
            self.inputField.textColor = color
        }
        if let color = floatingColor {
            self.floatingLabel.textColor = color
        }
        self.errorLabel.textColor = errorColor
        self.floatingLabel.text = floatingText
        if let borderView = self.inputField.superview {
            borderView.layer.borderColor = self.borderColor?.cgColor
            borderView.layer.borderWidth = self.borderWidth
            borderView.layer.cornerRadius = self.radius
        }
    }
    
    func showError(_ message: String = "") {
        errorLabel.text = message
        errorLabel.superview?.isHidden = message.isEmpty
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.updatePlaceholderFrame(!(self.inputField.text?.isEmpty ?? true))
        self.showError()
    }
}

public extension UIView {
    
  static func nib<T: UIView>(withClass type: T.Type) -> T? {
    return Bundle.main.loadNibNamed(String(describing: type), owner: self, options: nil)?.first as? T
  }
  
  static func nib(withName: String) -> Self? {
    return Bundle.main.loadNibNamed(String(describing: withName), owner: self, options: nil)?.first as? Self
  }
  
  static func nib() -> Self? {
    return nib(withName: String(describing: self))
  }
}

extension UIView {
    
    func loadNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: Self.self), bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func setupNib() {
        guard let nib = loadNib() else { return }
        nib.translatesAutoresizingMaskIntoConstraints = false
        _ = subviews.map { $0.removeFromSuperview() }
        addSubview(nib)
        NSLayoutConstraint.activate([
            nib.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            nib.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            nib.topAnchor.constraint(equalTo: self.topAnchor),
            nib.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension Reactive where Base: FloatingTextField {
    
    var validationResult: Binder<ValidationResult> {
        return Binder(base) { textField, result in
            textField.showError(result.description)
        }
    }
}
