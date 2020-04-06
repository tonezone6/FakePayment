//
//  Product+PaymentRequest.swift
//  NonReactiveViewModel
//
//  Created by Alex on 01/02/2020.
//  Copyright © 2020 tonezone. All rights reserved.
//

import PassKit

extension Product {
    var payment: PKPaymentRequest {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "amazon.applePay"
        request.supportedNetworks = [.visa, .masterCard, .amex]
        request.countryCode = "US"
        request.currencyCode = "USD"
        request.merchantCapabilities = .capabilityCredit
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: name, amount: price.decimal),
            PKPaymentSummaryItem(label: "Amazon.com", amount: price.decimal)
        ]
        return request
    }
}

enum PaymentStatus: String {
    case ready = "Buy"
    case authorizing = "Authorizing"
    case verifying = "Verifying"
    case processing = "Processing"
    case finished = "Thank You!"
}

extension Double {
    var decimal: NSDecimalNumber {
        return NSDecimalNumber(value: self)
    }
}
