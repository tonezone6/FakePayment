//
//  FakeStripe.swift
//  NonReactiveViewModel
//
//  Created by Alex on 29/01/2020.
//  Copyright © 2020 tonezone. All rights reserved.
//

import PassKit

public protocol StripeServiceProtocol {
    func createToken(with: PKPayment, completion: @escaping (Result<StripeToken, Error>) -> Void)
}

struct StripeService: StripeServiceProtocol {
    func createToken(with: PKPayment, completion: @escaping (Result<StripeToken, Error>) -> Void) {
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 3)
            DispatchQueue.main.async {
                print("TOKEN ****stripe****token")
                completion(.success("****stripe****token"))
            }
        }
    }
}

public typealias StripeToken = String

enum StripeError: LocalizedError {
    case cannotCreateToken
    
    var errorDescription: String? {
        switch self {
        case .cannotCreateToken:
            return "Stripe error! Cannot create token."
        }
    }
}
