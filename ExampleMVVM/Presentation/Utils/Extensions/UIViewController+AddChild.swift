//
//  UIViewController+AddChild.swift
//  ExampleMVVM
//
//  Created by Oleh Kudinov on 25.08.19.
//

import UIKit

extension UIViewController {
    
    func add(child: UIViewController, container: UIView) {
        
        //컨테이너 뷰컨(parent)에서 child 추가
        addChild(child)
        
        //???: frame은 슈퍼 뷰를 기준으로 어디에 얼마큼 떨어져 있는지이다.까지는 이해를 했는데 bounds는 자기 자신의 좌표계에서의 위치와 사이즈를 결정하는 것이라는 말이 잘 이해가 가지 않고 child 뷰컨의 슈퍼뷰 기준 좌표에 컨테이너의 bounds를 넣는다는 건 child의 슈퍼뷰를 컨테이너로 만들겠다는 뜻인가요...? addSubview와는 뭐가 다른 건가요...?
        child.view.frame = container.bounds
        
        //child vc의 루트뷰를 컨테이너(parent view)의 계층구조에 연결
        container.addSubview(child.view)
        
        //child가 parent에 추가되었을 때 호출됨.
        //???: 근데 호출되면 뭐하는 거죠?.?.?
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
