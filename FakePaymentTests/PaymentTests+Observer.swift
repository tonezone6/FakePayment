//
//  PaymentTests+Observer.swift
//  FakePaymentTests
//
//  Created by Alex on 06/04/2020.
//  Copyright © 2020 tonezone. All rights reserved.
//

@testable import FakePayment

extension FakePaymentTests {
    struct PaymentState {
        var loading:        [Bool] = []
        var status:         [PaymentStatus] = []
        var productVisible: [Bool] = []
        var paymentEnabled: [Bool] = []
        var failure:        [String?] = []
    }
    
    func setupObserver(with model: PaymentViewModel) {
        model.output.loading.addObserver(self) { (obs, loading) in
            obs.state.loading.append(loading)
        }
        
        model.output.status.addObserver(self) { (obs, status) in
            obs.state.status.append(status)
        }
        
        model.output.productVisible.addObserver(self) { (obs, visible) in
            obs.state.productVisible.append(visible)
        }
        
        model.output.paymentEnabled.addObserver(self) { (obs, enabled) in
            obs.state.paymentEnabled.append(enabled)
        }
        
        model.output.failure.addObserver(self) { (obs, message) in
            obs.state.failure.append(message)
        }
    }
}
