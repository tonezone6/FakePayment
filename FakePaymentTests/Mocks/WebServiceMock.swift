//
//  WebServiceMock.swift
//  FakePaymentTests
//
//  Created by Alex on 06/04/2020.
//  Copyright © 2020 tonezone. All rights reserved.
//

import Foundation
import FakePayment

struct WebServiceMock: WebServiceProtocol {
    var error: Error?
    
    func process(token: StripeToken, completion: @escaping (Result<Bool, Error>) -> Void) {
        if let error = self.error {
            return completion(.failure(error))
        }
        completion(.success(true))
    }
}
