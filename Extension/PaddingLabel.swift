//
//  PaddingLabel.swift
//  PickMemo
//
//  Created by kant on 2022/12/14.
//

import UIKit

/**
- Note:레이블 내에  뷰와 텍스트사이에 간격을 상하좌우를 지정할 수있는 커스텀레이블 클래스
 */

class PaddingLabel: UILabel {

    var topInset: CGFloat // 상
    var bottomInset: CGFloat // 하
    var leftInset: CGFloat // 좌
    var rightInset: CGFloat // 우

    
    /**
    - Parameters:
        -  top  : 상단 패딩
        -  bottom  : 하단 패딩
        -  left  : 왼쪽 패딩
        -  right  : 오른쪽  패딩
     */
    required init(withInsets top: CGFloat, _ bottom: CGFloat,_ left: CGFloat,_ right: CGFloat) {
        self.topInset = top
        self.bottomInset = bottom
        self.leftInset = left
        self.rightInset = right
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}
