//
//  Webservice.swift
//  NonReactiveViewModel
//
//  Created by Alex on 29/01/2020.
//  Copyright © 2020 tonezone. All rights reserved.
//

import Foundation

public protocol WebServiceProtocol {
    func process(token: StripeToken, completion: @escaping (Result<Bool, Error>) -> Void)
}

struct WebService: WebServiceProtocol {
    func process(token: StripeToken, completion: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 2)
            
            guard token != "****wrong****token" else {
                return completion(.failure(WebServiceError.wrongToken))
            }
            
            DispatchQueue.main.async {
                completion(.success(true))
            }
        }
    }
}

enum WebServiceError: LocalizedError {
    case wrongToken
    
    var errorDescription: String? {
        switch self {
        case .wrongToken:
            return "Cannot process payment! Wrong token."
        }
    }
}
