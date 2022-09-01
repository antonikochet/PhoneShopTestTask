//
//  Networking.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 30.08.2022.
//

import Foundation

protocol Networking {
    func getMainScreenData(completion: @escaping (Result<MainScreenData, Error>) -> Void)
    func loadImageData(_ urlString: String, completion: @escaping (Result<Data, Error>) -> Void)
}
