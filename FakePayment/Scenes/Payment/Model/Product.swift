//
//  Product.swift
//  NonReactiveViewModel
//
//  Created by Alex on 29/01/2020.
//  Copyright © 2020 tonezone. All rights reserved.
//

struct Product {
    let name: String
    let price: Double
}

extension Product {
    static var airpodsPro: Product {
        return Product(name: "Apple AirPods Pro\nwith charging case (2019)", price: 279.99)
    }
}
