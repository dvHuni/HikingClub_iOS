//
//  SettingViewController.swift
//  HikingClub
//
//  Created by AhnSangHoon on 2021/11/03.
//

import UIKit

final class SettingViewController: BaseViewController<BaseViewModel> {
    private let navigationBar: NaviBar = {
        let view = NaviBar()
        view.setTitle("설정")
        view.setBackItemImage()
        
        return view
    }()
    
    private let scrollView = UIScrollView()
    
    private let scrollContentsView = UIView()
    
    private let menuStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    private let townMenu = MenuButtonView(.town)
    
    private let personalInformationMenu = MenuButtonView(.personlInformation)
    
    private let versionMenu = MenuButtonView(.version)
    
    private let noticeMenu = MenuButtonView(.notice)
    
    private let inquiryMenu = MenuButtonView(.inquiry)
    
    private let logoutMenu = MenuButtonView(.logout)
    
    private let withdrawMenu = MenuButtonView(.withdraw)
    
    private let opensourceMenu = MenuButtonView(.opensource)
    
    // MARK: - Layout
    
    override func layout() {
        super.layout()
        view.addSubViews(navigationBar, scrollView)
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view)
        }
        scrollView.addSubview(scrollContentsView)
        scrollContentsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            
            $0.width.equalTo(view)
        }
        scrollContentsViewLayout()
    }
    
    private func scrollContentsViewLayout() {
        scrollContentsView.addSubview(menuStackView)
        menuStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(41)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        menuStackViewLayout()
    }
    
    private func menuStackViewLayout() {
        menuStackView.addArrangedSubviews(townMenu,
                                          personalInformationMenu,
                                          versionMenu,
                                          inquiryMenu,
                                          logoutMenu,
                                          withdrawMenu,
                                          opensourceMenu)
    }
    
    
    // MARK: - Bind
    
    override func bind() {
        super.bind()
        navigationBar.rx.tapLeftItem
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
