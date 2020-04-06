//
//  PaymentView.swift
//  FakePayment
//
//  Created by Alex on 03/04/2020.
//  Copyright © 2020 tonezone. All rights reserved.
//

import UIKit
import SwiftHelpers

final class PaymentView: UIView {
    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    private var buyButton = LoadingButton()
    
    var didTapBuyButton: () -> Void = {}
    
    private var product: Product
    
    init(product: Product) {
        self.product = product
        super.init(frame: .zero)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        didTapBuyButton()
    }
    
    func product(_ visible: Bool) {
        imageView.isHidden = !visible
        descriptionLabel.isHidden = !visible
    }
    
    func loading(_ loading: Bool) {
        buyButton.loading(loading)
    }
    
    func payment(_ enabled: Bool) {
        buyButton.enabled(enabled)
    }
    
    func change(_ status: String) {
        buyButton.change(status: status)
    }
}

extension PaymentView {
    private func configureSubviews() {
        backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        addSubview(stackView, constraints: [
            .centerX, .centerY, .width(multiplier: 0.7)
        ])
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16
        
        imageView.image = .airpods
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        stackView.addArrangedSubview(imageView)
        
        descriptionLabel.textColor = .lightGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = .systemFont(ofSize: 15, weight: .regular)
        descriptionLabel.text = product.name
        stackView.addArrangedSubview(descriptionLabel)
        
        buyButton.setTitle("Buy", for: .normal)
        buyButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        buyButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(buyButton)
    }
}

extension UIImage {
    static let airpods = UIImage(named: "airpods")
}
