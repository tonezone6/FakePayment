//
//  ViewController.swift
//  NonReactiveViewModel
//
//  Created by Alex on 29/01/2020.
//  Copyright © 2020 tonezone. All rights reserved.
//

import UIKit

final class PaymentViewController: UIViewController {
    private var paymentView: PaymentView
    private var model: PaymentViewModel
    private var authorizer: PaymentAuthorizer
    
    init(model: PaymentViewModel) {
        self.model = model
        paymentView = PaymentView(product: model.product)
        authorizer = PaymentAuthorizer(request: model.product.payment)
    
        super.init(nibName: nil, bundle: nil)
        
        paymentView.didTapBuyButton = { [unowned self] in
            self.model.input.buyButtonTapped()
            self.authorizer.presentPayment()
        }
        
        setupAuthorizer()
        observeViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = paymentView
    }
    
    private func setupAuthorizer() {
        authorizer.authorized = { [unowned self] auth in
            self.model.input.authorize(with: auth)
        }
        
        authorizer.finished = { [unowned self] in
            self.model.input.finishAuthorization()
        }
    }
    
    private func observeViewModel() {
        model.output.loading.addObserver(self) { (vc, isLoading) in
            vc.paymentView.loading(isLoading)
        }
        
        model.output.productVisible.addObserver(self) { (vc, visible) in
            vc.paymentView.product(visible)
        }
        
        model.output.status.addObserver(self) { (vc, status) in
            vc.paymentView.change(status.rawValue)
        }
        
        model.output.paymentEnabled.addObserver(self) { (vc, enabled) in
            vc.paymentView.payment(enabled)
        }
        
        model.output.failure.addObserver(self) { (vc, message) in
            guard let alert = message, !alert.isEmpty else { return }
            vc.authorizer.dismiss()
            vc.presentAlert(message: alert)
        }
    }
}
