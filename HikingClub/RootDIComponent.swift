//
//  RootDIComponent.swift
//  HikingClub
//
//  Created by Ahn Sang Hoon on 2022/04/04.
//

import UIKit
import NeedleFoundation

final class RootDIComponent: BootstrapComponent {
    var tabBarController: MainTabBarController {
        MainTabBarController(
            mainTabBarDIComponent.homeDIComponent,
            mainTabBarDIComponent.searchDIComponent,
            mainTabBarDIComponent.writeDIComponent,
            mainTabBarDIComponent.myPageDIComponent,
            mainTabBarDIComponent.loginDIComponent
        )
    }
    
    lazy var mainTabBarDIComponent: MainTabBarDIComponent = {
        return MainTabBarDIComponent(parent: self)
    }()
}

// MARK: - TabBarController

protocol MainTabBarControllerBuilder {
    var viewController: MainTabBarController { get }
}

final class MainTabBarDIComponent: Component<EmptyDependency>, MainTabBarControllerBuilder {
    var viewController: MainTabBarController {
        return MainTabBarController(
            homeDIComponent,
            searchDIComponent,
            writeDIComponent,
            myPageDIComponent,
            loginDIComponent
        )
    }
    
    var homeDIComponent: HomeDIComponent {
        return HomeDIComponent(parent: self)
    }
    
    var searchDIComponent: SearchDIComponent {
        return SearchDIComponent(parent: self)
    }
    
    var writeDIComponent: WriteDIComponent {
        return WriteDIComponent(parent: self)
    }
    
    var myPageDIComponent: MyPageDIComponent {
        return MyPageDIComponent(parent: self)
    }
    
    var loginDIComponent: LoginDIComponent {
        return LoginDIComponent(parent: self)
    }
}

// MARK: - Home

protocol HomeViewControllerBuilder {
    var viewController: HomeViewController { get }
}

final class HomeDIComponent: Component<EmptyDependency>, HomeViewControllerBuilder {
    lazy var viewController: HomeViewController = {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        return storyBoard.instantiate("HomeViewController") { coder -> HomeViewController in
                .init(coder, HomeViewModel()) ?? HomeViewController(HomeViewModel())
        }
    }()
}

// MARK: - Search

protocol SearchViewControllerBuilder {
    var viewController: SearchViewController { get }
}

final class SearchDIComponent: Component<EmptyDependency>, SearchViewControllerBuilder {
    var viewController: SearchViewController = {
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        return storyboard.instantiate("SearchViewController") { coder -> SearchViewController? in
                .init(coder, SearchViewModel())
        }
    }()
}

// MARK: - Write

protocol WriteViewControllerBuilder {
    var viewController: UIViewController { get }
}

final class WriteDIComponent: Component<EmptyDependency>, WriteViewControllerBuilder {
    var viewController: UIViewController = {
        UIViewController()
    }()
}

// MARK: - MyPage

protocol MyPageViewControllerBuilder {
    var viewController: MyPageViewController { get }
}

final class MyPageDIComponent: Component<EmptyDependency>, MyPageViewControllerBuilder {
    var viewController: MyPageViewController = {
        MyPageViewController(MyPageViewModel())
    }()
}

// MARK: - Login

protocol LoginNavigationViewControllerBuilder {
    var viewController: LoginNavigationViewController { get }
}

final class LoginDIComponent: Component<EmptyDependency>, LoginNavigationViewControllerBuilder {
    var viewController: LoginNavigationViewController = {
        LoginNavigationViewController(LoginNavigationViewModel())
    }()
}
