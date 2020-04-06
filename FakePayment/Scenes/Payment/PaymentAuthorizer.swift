//
//  PaymentDelegate.swift
//  FakePayment
//
//  Created by Alex on 04/04/2020.
//  Copyright © 2020 tonezone. All rights reserved.
//

import PassKit

public typealias PaymentAuthorization = (payment: PKPayment, result: (PKPaymentAuthorizationResult) -> Void)

class PaymentAuthorizer: NSObject, PKPaymentAuthorizationViewControllerDelegate {
    private var request: PKPaymentRequest
    private var controller: PKPaymentAuthorizationViewController!
    
    var authorized: (PaymentAuthorization) -> Void = { _ in }
    var finished: () -> Void = { }
    
    init(request: PKPaymentRequest) {
        self.request = request
        super.init()
    }
    
    func presentPayment() {
        guard let root = UIApplication.shared.windows.first?.rootViewController else { fatalError() }
        controller = PKPaymentAuthorizationViewController(paymentRequest: request)
        controller.delegate = self
        root.present(controller, animated: true)
    }
    
    func dismiss() {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                            didAuthorizePayment payment: PKPayment,
                                            handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        authorized((payment, completion))
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        finished()
        controller.dismiss(animated: true, completion: nil)
    }
}
