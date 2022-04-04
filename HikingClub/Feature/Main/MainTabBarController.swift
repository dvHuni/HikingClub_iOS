//
//  MainTabBarController.swift
//  HikingClub
//
//  Created by AhnSangHoon on 2021/09/20.
//

import UIKit
import RxSwift
import RxRelay

final class MainTabBarController: UITabBarController {
    private let homeViewController: UINavigationController
    private let searchViewController: UINavigationController
    private let writeViewController: UINavigationController
    private let myPageViewController: UINavigationController
    private let loginViewCotroller: UINavigationController
    
    init(
        _ home: HomeViewControllerBuilder,
        _ search: SearchViewControllerBuilder,
        _ write: WriteViewControllerBuilder,
        _ myPage: MyPageViewControllerBuilder,
        _ login: LoginNavigationViewControllerBuilder
    ) {
        homeViewController = home.viewController.wrappedByNavigationController()
        searchViewController = search.viewController.wrappedByNavigationController()
        writeViewController = write.viewController.wrappedByNavigationController()
        myPageViewController = myPage.viewController.wrappedByNavigationController()
        loginViewCotroller = login.viewController.wrappedByNavigationController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum TabBarIndex: Int {
        case home
        // TODO: 첫 심사 시 기능 미완료로 검색 탭바 숨김 처리
        // case search
        case write
        case myPage
    }
    
    private let homeTabBarItem = UITabBarItem(normalAsset: .icon_tabbar_house_deselected_gray200_28,
                                              selectedAsset: .icon_tabbar_house_selected_green900_28)
    
    private let searchTabBarItem = UITabBarItem(normalAsset: .icon_tabbar_magnifier_left_deselected_gray200_28,
                                                selectedAsset: .icon_tabbar_magnifier_left_selected_green900_28)
    
    private let writeTabBarItem = UITabBarItem(normalAsset: .icon_tabbar_pencil_deselected_gray200_28,
                                               selectedAsset: .icon_tabbar_pencil_selected_green900_28)
    
    private let mypageTabBarItem = UITabBarItem(normalAsset: .icon_tabbar_person_deselected_gray200_28,
                                                selectedAsset: .icon_tabbar_person_selected_green900_28)
    private let disposeBag = DisposeBag()
    
    private var previousTabIndex: Int = .zero
    
    let selectTab = PublishRelay<TabBarIndex>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = .white
        tabBar.backgroundColor = .white
        homeViewController.tabBarItem = homeTabBarItem
        // TODO: 첫 심사 시 기능 미완료로 검색 탭바 숨김 처리
        // searchViewController.tabBarItem = searchTabBarItem
        writeViewController.tabBarItem = writeTabBarItem
        myPageViewController.tabBarItem = mypageTabBarItem
        
        // TODO: 첫 심사 시 기능 미완료로 검색 탭바 숨김 처리
        // setViewControllers([homeViewController, searchViewController, writeViewController, myPageViewController], animated: false)
        setViewControllers([homeViewController, writeViewController, myPageViewController], animated: false)
        
        bind()
    }
    
    func bind() {
        self.rx.didSelect
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.selectedIndexProcess(self.selectedIndex)
            })
            .disposed(by: disposeBag)
        
        selectTab
            .subscribe(onNext: { [weak self] in
                self?.selectedIndex = $0.rawValue
                self?.selectedIndexProcess($0.rawValue)
            })
            .disposed(by: disposeBag)
        
        // TODO: 리팩터링
        NotificationCenter.default.rx.notification(Notification.Name.invalidToken, object: nil)
            .subscribe(onNext: { [weak self] _ in
                NDToastView.shared.rx.showText.onNext(.red(text: NetworkError.invalidToken.description))
                
                self?.selectTab.accept(.home)
                self?.popAllNavigationController()
            })
            .disposed(by: disposeBag)
    }
    
    private func checkLogin() -> Bool {
        return false == UserInformationUserDefault(key: .token).isEmpty
    }
    
    private func selectedIndexProcess(_ index: Int) {
        if index == TabBarIndex.write.rawValue {
            selectedIndex = previousTabIndex
            if checkLogin() {
                let webViewController = WebViewController(WebViewModel(for: .write))
                webViewController.modalPresentationStyle = .fullScreen
                present(webViewController, animated: true, completion: nil)
            } else {
                presentLoginViewController()
            }
        } else if index == TabBarIndex.myPage.rawValue {
            if false == checkLogin() {
                selectedIndex = previousTabIndex
                presentLoginViewController()
            } else {
                previousTabIndex = index
            }
        } else {
            previousTabIndex = index
        }
    }
    
    private func presentLoginViewController() {
        let viewController = LoginNavigationViewController(LoginNavigationViewModel()).wrappedByNavigationController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    private func popAllNavigationController() {
        homeViewController.popToRootViewController(animated: false)
        searchViewController.popToRootViewController(animated: false)
        writeViewController.popToRootViewController(animated: false)
        myPageViewController.popToRootViewController(animated: false)
    }
    
#if DEBUG
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        if event?.subtype == .motionShake {
            let testVC = ComponentTestViewController()
            present(testVC, animated: true)
        }
    }
#endif
}
