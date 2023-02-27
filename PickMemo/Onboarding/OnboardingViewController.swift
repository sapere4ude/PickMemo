//
//  OnboardingViewController.swift
//  PickMemo
//
//  Created by Kant on 2023/02/27.
//

import UIKit
import SnapKit

class OnboardingViewController: UIViewController, UIScrollViewDelegate {
    
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    let confirmButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        button.titleLabel?.text = "확인"
        button.backgroundColor = .systemGray6
        return button
    }()

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
        
        // TODO: - 이미지를 넣는 배열이 아닌 뷰를 넣어주는 배열로 변경해보기
        // 지금의 방식은 확인버튼이 너무나 어색해보이는 문제가 있음
        let images: [UIImage] = [UIImage(named: "onboarding1")!, UIImage(named: "onboarding2")!]
        
        for i in 0..<images.count {
            let imageView = UIImageView(frame: CGRect(x: CGFloat(i) * imageWidth, y: 0, width: imageWidth, height: imageHeight))
            imageView.contentMode = .scaleAspectFit
            imageView.image = images[i]
            scrollView.addSubview(imageView)
        }
        
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(images.count), height: view.frame.height)
        
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.width.equalTo(view.bounds.width/1.5)
            $0.height.equalTo(40)
            $0.bottom.equalTo(pageControl.snp.top).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        confirmButton.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        pageControl.frame = CGRect(x: 0, y: view.frame.maxY - 100, width: view.frame.width, height: 100)
    }
    
    func setupConfirmButton() {
//        view.addSubview(confirmButton)
//        confirmButton.snp.makeConstraints {
//            $0.width.equalTo(view.bounds.width/1.5)
//            $0.height.equalTo(40)
//            $0.bottom.equalTo(pageControl.snp.top).offset(5)
//            $0.centerX.equalToSuperview()
//        }
        confirmButton.isHidden = false
    }
    
    func removeConfirmButton() {
        if scrollView.contains(confirmButton) {
            //confirmButton.removeFromSuperview()
            confirmButton.isHidden = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
//
//        guard !(pageNumber.isNaN || pageNumber.isInfinite) else { return }
//        pageControl.currentPage = Int(pageNumber)
//
//        print(#fileID, #function, #line, "칸트")
//
//        if pageControl.currentPage == 0 {
//            confirmButton.removeFromSuperview()
//        } else if pageControl.currentPage == 1 {
//            setupConfirmButton()
//        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)

        guard !(pageNumber.isNaN || pageNumber.isInfinite) else { return }
        pageControl.currentPage = Int(pageNumber)

        print(#fileID, #function, #line, "칸트")

        if pageControl.currentPage == 0 {
            //confirmButton.removeFromSuperview()
            self.confirmButton.isHidden = true
        } else if pageControl.currentPage == 1 {
            //setupConfirmButton()
            self.confirmButton.isHidden = false
        }
    }
}

class Onboarding2: UIView {
    
}
