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
    let dispose = DisposeBag()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        configGesture()
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
                case .began, .changed:
                    let translation = gesture.translation(in: self.superview)
                    self.center = CGPoint(
                        x: self.center.x + translation.x,
                        y: self.center.y + translation.y
                    )
                    gesture.setTranslation(.zero, in: self.superview)
                case .ended:
                    break
                default:
                    break
                    
                }
            }
            ).disposed(by: dispose)
    }
}
