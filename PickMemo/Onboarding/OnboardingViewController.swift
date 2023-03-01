//
//  OnboardingViewController.swift
//  PickMemo
//
//  Created by Kant on 2023/02/27.
//

import UIKit
import SnapKit
import CoreLocation
import RxCocoa

class OnboardingViewController: UIViewController, UIScrollViewDelegate, PresentVC {
    
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        view.addSubview(scrollView)
        
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.green2
        
        view.addSubview(pageControl)
        
        let imageWidth = view.frame.width
        let imageHeight = view.frame.height
        
        let firstOnboarding = FirstOnboarding()
        let secondOnboarding = SecondOnboarding()
        
        secondOnboarding.delegate = self
        
        let uiviews: [UIView] = [firstOnboarding, secondOnboarding]
        
        for i in 0..<uiviews.count {
            uiviews[i].frame = CGRect(x: CGFloat(i) * imageWidth, y: 0, width: imageWidth, height: imageHeight)
            scrollView.addSubview(uiviews[i])
        }
        
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(uiviews.count), height: view.frame.height)
    }
    
    func test() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabBarController = MainTabBarViewController()
        if let window = view.window {
            tabBarController.modalPresentationStyle = .fullScreen
            window.rootViewController?.present(tabBarController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        pageControl.frame = CGRect(x: 0, y: view.frame.maxY - 100, width: view.frame.width, height: 100)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        guard !(pageNumber.isNaN || pageNumber.isInfinite) else { return }
        pageControl.currentPage = Int(pageNumber)
    }
}

class FirstOnboarding: UIView {
    
    let onboardingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "onboarding1")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemYellow
        
        self.addSubview(onboardingImage)
        onboardingImage.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol PresentVC {
    func test()
}

class SecondOnboarding: UIView, CLLocationManagerDelegate {
    
    var delegate: PresentVC?
    
    var locationManager = CLLocationManager()
    
    let onboardingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "onboarding2")
        return imageView
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.blackThree, for: .normal)
        button.backgroundColor = .systemGray6
        button.isUserInteractionEnabled = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        locationManager.delegate = self
        
        self.addSubview(onboardingImage)
        self.addSubview(confirmButton)
        
        onboardingImage.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
        confirmButton.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width / 1.5)
            $0.height.equalTo(40)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-60)
            $0.centerX.equalToSuperview()
        }
        
        confirmButton.addTarget(self, action: #selector(pressButton), for: .touchUpInside)
    }
    
    @objc func pressButton() {
        // 권한 상태를 확인합니다.
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            // 권한이 허용되어 있다면 rootviewcontroller로 이동합니다.
            goToRootViewController()
        } else {
            // 권한이 거부되었거나 아직 사용자의 선택이 필요한 경우 권한 요청을 시작합니다.
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 권한 상태가 변경되면 호출됩니다.
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            // 권한이 허용되어 있다면 rootviewcontroller로 이동합니다.
            goToRootViewController()
        }
    }
    
    // 위치 상태 확인
    func goToRootViewController() {
        // rootviewcontroller로 이동하는 코드를 작성합니다.
        // 예를 들어, 다음과 같이 UINavigationController를 사용하여 이동할 수 있습니다.
        
        delegate?.test()
        //present(navigationController, animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
