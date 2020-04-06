//
//  NonReactiveViewModelTests.swift
//  NonReactiveViewModelTests
//
//  Created by Alex on 29/01/2020.
//  Copyright © 2020 tonezone. All rights reserved.
//

import XCTest
import PassKit
@testable import FakePayment

class FakePaymentTests: XCTestCase {    
    var state: PaymentState!
    
    override func setUp() {
        state = PaymentState()
    }
    
    override func tearDown() {
        state = nil
    }
    
    func testInitialState() {
        // given
        let stripeService = StripeServiceMock(token: "")
        
        // when
        let model = PaymentViewModel(stripeService: stripeService, webService: WebServiceMock())
        setupObserver(with: model)

        // then
        XCTAssertEqual(state.loading, [false])
        XCTAssertEqual(state.status, [.ready])
        XCTAssertEqual(state.productVisible, [true])
        XCTAssertEqual(state.paymentEnabled, [true])
        XCTAssertEqual(state.failure, [nil])
    }

    func testBuyButtonTapped() {
        // given
        let stripeService = StripeServiceMock(token: "")
        let model = PaymentViewModel(stripeService: stripeService, webService: WebServiceMock())
        setupObserver(with: model)
        
        // when
        model.input.buyButtonTapped()
        
        // then
        XCTAssertEqual(state.loading, [false, true])
        XCTAssertEqual(state.productVisible, [true, false])
        XCTAssertEqual(state.status, [.ready, .authorizing])
    }
    
    func testAuthorizationCanceled() {
        // given
        let stripeService = StripeServiceMock(token: "")
        let model = PaymentViewModel(stripeService: stripeService, webService: WebServiceMock())
        setupObserver(with: model)
        
        // when
        model.input.buyButtonTapped()
        model.input.finishAuthorization()
        
        // then
        XCTAssertEqual(state.loading, [false, true, false])
        XCTAssertEqual(state.productVisible, [true, false, true])
        XCTAssertEqual(state.status, [.ready, .authorizing, .ready])
    }
    
    func testStripeCreateTokenFailure() {
        // given
        let stripeService = StripeServiceMock(error: StripeError.cannotCreateToken)
        let authorizer = PaymentAuthorizerMock()
        
        let model = PaymentViewModel(stripeService: stripeService, webService: WebServiceMock())
        setupObserver(with: model)
        
        // when
        model.input.buyButtonTapped()
        model.input.authorize(with: authorizer.auth)
        
        // then
        XCTAssertEqual(state.status, [.ready, .authorizing, .verifying])
        XCTAssertEqual(state.failure, [nil, "Stripe error! Cannot create token."])
    }
    
    func testProcessTokenFailure() {
        // given
        let webService = WebServiceMock(error: WebServiceError.wrongToken)
        let authorizer = PaymentAuthorizerMock()
        
        let model = PaymentViewModel(stripeService: StripeServiceMock(token: "token"), webService: webService)
        setupObserver(with: model)
        
        // when
        model.input.buyButtonTapped()
        model.input.authorize(with: authorizer.auth)
        
        // then
        XCTAssertEqual(state.status, [.ready, .authorizing, .verifying, .processing])
        XCTAssertEqual(state.failure, [nil, "Cannot process payment! Wrong token."])
    }
    
    func testAuthorizationSuccess() {
        // given
        let stripeService = StripeServiceMock(token: "token")
        let webService = WebServiceMock()
        let authorizer = PaymentAuthorizerMock()
        
        let model = PaymentViewModel(stripeService: stripeService, webService: webService)
        setupObserver(with: model)
        
        // when
        model.input.buyButtonTapped()
        model.input.authorize(with: authorizer.auth)
        model.input.finishAuthorization()
        
        // then
        XCTAssertEqual(state.loading, [false, true, false])
        XCTAssertEqual(state.paymentEnabled, [true, false])
        XCTAssertEqual(state.status, [.ready, .authorizing, .verifying, .processing, .finished])
    }
}
