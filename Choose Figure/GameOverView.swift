//
//  GameOverView.swift
//  Choose Figure
//
//  Created by 许浩渊 on 2022/6/21.
//  Copyright © 2022 ivansosnovik. All rights reserved.
//

import Foundation
import XHYCategories
import UIKit
import SnapKit


class GameOverView: UIView {

    var retryHandler: VoidHandler?
    private let tipsLabel = UILabel(text: "GameOver", font: UIFont.systemFont(ofSize: 26, weight: .black), color: .black, alignment: .center)

    private let maxLevel = UILabel(text: "High Level: 0", font: UIFont.systemFont(ofSize: 23 , weight: .heavy), color: .black, alignment: .center)

    private let retryButton = UIButton(title: "Retry", titleColor: UIColor.black, font: UIFont.systemFont(ofSize: 21, weight: .bold), edge: UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24), borderWidth: 3, borderColor: UIColor.black)

    init(score: Int) {
        super.init(frame: .zero)
        layer.borderWidth = 3
        layer.borderColor = UIColor.black.cgColor
        backgroundColor = UIColor(hex: "86C7FF")

        maxLevel.text = "High Level: \(score)"
        let stackView = UIStackView(subviews: [tipsLabel, maxLevel, retryButton], axis: .vertical, alignment: .fill, distribution: .fill, spacing: 24)

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 32, left: 32, bottom: 32, right: 32))
        }

        retryButton.addTapHandler { [weak self] in
            self?.retryHandler?()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
