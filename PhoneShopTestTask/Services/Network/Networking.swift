//
//  Networking.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 30.08.2022.
//

import Foundation

protocol Networking {
    func getMainScreenData(completion: @escaping (Result<MainScreenData, Error>) -> Void)
    func getDetailsScreenData(for id: Int, completion: @escaping (Result<DetailsData, Error>) -> Void)
    func loadImageData(_ urlString: String, completion: @escaping (Result<Data, Error>) -> Void)
}
