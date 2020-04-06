//
//  ViewModel.swift
//  NonReactiveViewModel
//
//  Created by Alex on 29/01/2020.
//  Copyright © 2020 tonezone. All rights reserved.
//

import PassKit

protocol PaymentViewModelOutput {
    var loading:        Observable<Bool> { get set }
    var productVisible: Observable<Bool> { get set }
    var status:         Observable<PaymentStatus> { get set }
    var paymentEnabled: Observable<Bool> { get set }
    var failure:        Observable<String?> { get set }
}

protocol PaymentViewModelInput {
    func buyButtonTapped()
    func authorize(with auth: PaymentAuthorization)
    func finishAuthorization()
}

final class PaymentViewModel: PaymentViewModelOutput {
    private(set) var product: Product
    
    private let stripeService: StripeServiceProtocol
    private let webService: WebServiceProtocol
    
    // User tapped cancel or
    // payment finished successfully.
    private var authorized = false
    
    var output: PaymentViewModelOutput { self }
    var input: PaymentViewModelInput   { self }
    
    var loading: Observable<Bool>
    var productVisible: Observable<Bool>
    var status: Observable<PaymentStatus>
    var paymentEnabled: Observable<Bool>
    var failure: Observable<String?>
    
    init(product: Product = Product.airpodsPro,
         stripeService: StripeServiceProtocol = StripeService(),
         webService: WebServiceProtocol = WebService()) {
        
        self.product = product
        self.stripeService = stripeService
        self.webService = webService
        
        // Initial state.
        loading = Observable(value: false)
        productVisible = Observable(value: true)
        status = Observable(value: .ready)
        paymentEnabled = Observable(value: true)
        failure = Observable(value: nil)
    }
}

extension PaymentViewModel: PaymentViewModelInput {
    func buyButtonTapped() {
        authorized = false

        loading.update(with: true)
        productVisible.update(with: false)
        status.update(with: .authorizing)
    }
    
    func authorize(with auth: PaymentAuthorization) {
        authorized = true
        
        status.update(with: .verifying)
        stripeService.createToken(with: auth.payment) { [unowned self] result in
            switch result {
            case .failure(let error):
                self.loading.update(with: false)
                self.failure.update(with: error.localizedDescription)
                auth.result(.init(status: .failure, errors: [error]))
                
            case .success(let token):
                self.status.update(with: .processing)
                
                self.webService.process(token: token) { [unowned self] result in
                    self.loading.update(with: false)
                    
                    switch result {
                    case .failure(let error):
                        self.failure.update(with: error.localizedDescription)
                        auth.result(.init(status: .failure, errors: [error]))
                    
                    case .success:
                        self.status.update(with: .finished)
                        auth.result(.init(status: .success, errors: nil))
                    }
                }
            }
        }
    }
    
    func finishAuthorization() {
        if authorized {
            paymentEnabled.update(with: false)
        } else {
            // Canceled.
            loading.update(with: false)
            status.update(with: .ready)
            productVisible.update(with: true)
            paymentEnabled.update(with: true)
        }
    }
}
