//
//  PaymentAuthorizerMock.swift
//  FakePaymentTests
//
//  Created by Alex on 06/04/2020.
//  Copyright © 2020 tonezone. All rights reserved.
//

import Foundation
import PassKit
import FakePayment

class PaymentAuthorizerMock {
    var auth: PaymentAuthorization
    var result: (PKPaymentAuthorizationResult) -> Void = { _ in }
    
    init() {
        auth = (PKPayment(), result)
    }

}
