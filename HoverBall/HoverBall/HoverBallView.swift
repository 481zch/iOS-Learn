////
////  HoverBall.swift
////  HoverBall
////
////  Created by zangconghui on 2025/3/26.
////
//
//import UIKit
//import SnapKit
//import Then
//import RxSwift
//import RxCocoa
//
//final class HoverBallView: UIView {
//    
//    private let panGesture = UIPanGestureRecognizer()
//    private var animator: UIViewPropertyAnimator?
//    let dispose = DisposeBag()
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .red
//        configGesture()
//        breathAnimaltion()
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        layer.cornerRadius = bounds.width / 2
//    }
//}
//
//private extension HoverBallView {
//    
//    func configGesture() {
//        addGestureRecognizer(panGesture)
//        panGesture.rx.event
//            .subscribe(onNext: { [weak self] gesture in
//                guard let self else { return }
//                switch gesture.state {
//                case .began:
//                    print("移除layer层动画")
//                    self.layer.removeAllAnimations()
////                    self.transform = .identity
//                case .changed:
//                    let translation = gesture.translation(in: self.superview)
//                    self.center = CGPoint(
//                        x: self.center.x + translation.x,
//                        y: self.center.y + translation.y
//                    )
//                    gesture.setTranslation(.zero, in: self.superview)
//                case .ended:
//                    self.performAnimaltion()
//                default:
//                    break
//                }
//            }
//        ).disposed(by: dispose)
//    }
//}
//
//private extension HoverBallView {
//    
//    func breathAnimaltion() {
//        UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse], animations: {
//            self.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
//            self.alpha = 0.5
//        })
//    }
//    
//    func performAnimaltion() {
//        UIView.animate(withDuration: 1.0, animations: {
//            let screenWidth = self.superview?.bounds.width ?? 0
//            self.center = CGPoint(x: screenWidth - self.bounds.width / 2, y: self.center.y)
//            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
//        }, completion: { _ in
//            UIView.animate(withDuration: 0.5) {
//                self.transform = .identity
//            }
//        })
//    }
//}
//
//  HoverBall.swift
//  HoverBall
//
//  Created by zangconghui on 2025/3/26.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class HoverBallView: UIView {
    
    private let panGesture = UIPanGestureRecognizer()
    private var animator: UIViewPropertyAnimator?
    let dispose = DisposeBag()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        configGesture()
        startBreathAnimation()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
}

private extension HoverBallView {
    
    func configGesture() {
        addGestureRecognizer(panGesture)
        
        panGesture.rx.event
            .subscribe(onNext: { [weak self] gesture in
                guard let self else { return }
                switch gesture.state {
                case .began:
                    self.layer.removeAnimation(forKey: "breath")
                case .changed:
                    let translation = gesture.translation(in: self.superview)
                    self.center = CGPoint(
                        x: self.center.x + translation.x,
                        y: self.center.y + translation.y
                    )
                    gesture.setTranslation(.zero, in: self.superview)
                case .ended:
                    self.performAnimaltion()
                    self.startBreathAnimation()
                default:
                    break
                }
            }
        ).disposed(by: dispose)
    }
    
    func startBreathAnimation() {
        // 基础动画，动画目标属性
        let anim = CABasicAnimation(keyPath: "transform.scale")
        anim.fromValue = 1.0
        anim.toValue = 0.75
        anim.duration = 1.5
        anim.autoreverses = true
        anim.repeatCount = .infinity
        // 设置动画的节奏曲线：慢-快-慢
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        // 叠加到现有变换上
        anim.isAdditive = false
        // 动画播放完成后是否移除
        anim.isRemovedOnCompletion = false
        // 动画结束后保持在最后一帧
        anim.fillMode = .forwards
        // 添加到当前视图的layer中
        layer.add(anim, forKey: "breath")
    }
}

private extension HoverBallView {
    
    func performAnimaltion() {
        UIView.animate(withDuration: 1.0, animations: {
            let screenWidth = self.superview?.bounds.width ?? 0
            self.center = CGPoint(x: screenWidth - self.bounds.width / 2, y: self.center.y)
            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.transform = .identity
            }
        })
    }
}
