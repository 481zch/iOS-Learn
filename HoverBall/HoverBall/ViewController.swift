//
//  ViewController.swift
//  HoverBall
//
//  Created by zangconghui on 2025/3/26.
//

import UIKit

class ViewController: UIViewController {
    
    private let hoverBall = HoverBallView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
    }
    
    private func setupSubviews() {
        view.addSubview(hoverBall)
        hoverBall.snp.makeConstraints { make in
            make.height.width.equalTo(60)
            make.right.centerY.equalToSuperview()
        }
    }

}

