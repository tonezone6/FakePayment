//
//  LoadingButton.swift
//  FakePayment
//
//  Created by Alex on 04/04/2020.
//  Copyright © 2020 tonezone. All rights reserved.
//

import UIKit

final class LoadingButton: UIButton {
    private var spinner = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loading(_ loading: Bool) {
        enabled(loading == false)
        loading ? spinner.startAnimating() : spinner.stopAnimating()
    }
    
    func enabled(_ enabled: Bool) {
        if enabled {
            backgroundColor = tintColor.withAlphaComponent(1.0)
            isUserInteractionEnabled = true
        } else {
            backgroundColor = tintColor.withAlphaComponent(0.7)
            isUserInteractionEnabled = false
        }
    }
    
    func change(status: String) {
        setTitle(status, for: .normal)
    }
}

extension LoadingButton {
    private func setup() {
        titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        setTitleColor(.white, for: .normal)
        tintColor = .systemTeal
        layer.cornerRadius = 6.0
        
        spinner.color = .white
        spinner.hidesWhenStopped = true
        
        guard let titleLabel = titleLabel else { return }
        let spacing: CGFloat = 8.0
        
        addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -spacing).isActive = true
        spinner.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
    }
}
