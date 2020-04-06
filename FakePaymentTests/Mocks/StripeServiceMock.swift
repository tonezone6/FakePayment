//
//  StripeServiceMock.swift
//  FakePaymentTests
//
//  Created by Alex on 06/04/2020.
//  Copyright © 2020 tonezone. All rights reserved.
//

import Foundation
import FakePayment
import PassKit

struct StripeServiceMock: StripeServiceProtocol {
    var error: Error?
    var token: StripeToken?
    
    init(error: Error) {
        self.error = error
    }
    
    init(token: String) {
        self.token = token
    }

    func createToken(with: PKPayment, completion: @escaping (Result<StripeToken, Error>) -> Void) {
        if let error = self.error {
            completion(.failure(error))
        }
        if let token = self.token {
            completion(.success(token))
        }
    }
}
