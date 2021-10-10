//
//  LoginNavigationViewController.swift
//  HikingClub
//
//  Created by AhnSangHoon on 2021/10/09.
//

import UIKit

final class LoginNavigationViewController: BaseViewController<LoginNavigationViewModel>, CodeBasedProtocol {
    private let navigationButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        
        return stackView
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setFont(.semiBold16)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("시작하기", for: .normal)
        
        return button
    }()
    
    private let emailLoginButton: UIButton = {
        let button = UIButton()
        button.setFont(.semiBold16)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("이메일 로그인", for: .normal)
        return button
    }()
    
    private let appleLoginButton: UIButton = {
        let button = UIButton()
        button.setFont(.semiBold16)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Apple 로그인", for: .normal)
        return button
    }()
    
    private let guestLoginButton: UIButton = {
        let button = UIButton()
        button.setFont(.semiBold16)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("바로 둘러보기 >", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
    }
    
    // MARK: - Layout
    
    func layout() {
        view.addSubview(navigationButtonStackView)
        navigationButtonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(38)
        }
        navigationButtonStackViewLayout()
    }
    
    private func navigationButtonStackViewLayout() {
        navigationButtonStackView.addArrangedSubviews(signUpButton,
                                                      emailLoginButton,
                                                      appleLoginButton,
                                                      guestLoginButton)
        buttonsLayout()
    }
    
    // TODO: 버튼 컴포넌트가 완료되면 되면 height이 결정되기 때문에 컴포넌트 적용 후 삭제
    private func buttonsLayout() {
        signUpButton.snp.makeConstraints {
            $0.height.equalTo(54)
        }
        emailLoginButton.snp.makeConstraints {
            $0.height.equalTo(54)
        }
        appleLoginButton.snp.makeConstraints {
            $0.height.equalTo(54)
        }
        guestLoginButton.snp.makeConstraints {
            $0.height.equalTo(54)
        }
    }
    
    // MARK: - Bind
    
    private func bind() {
        signUpButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigateToSignUpNavigationViewController()
            })
            .disposed(by: disposeBag)
        
        guestLoginButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func navigateToSignUpNavigationViewController() {
        let viewController = SignUpViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// TODO: Remove After Extension Merged
extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
}
