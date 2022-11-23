//
//  Networking.swift
//  Networking
//
//  Created by Rajneesh Biswal on 23/11/22.
//

import Foundation

enum NetworkingError: Error {
    case ResponseDataNotFound
    case ParseError(responseData: Data)
}

protocol Networking {
    func makeNetworkRequest<Endpoint: EndpointRequest>(_ endpoint: Endpoint,
                                                    completionHandler: @escaping (Result<Endpoint.ResponseType, Error>) -> Void)
}

final class HttpService: Networking {
    private var session: URLSession
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func makeNetworkRequest<Endpoint: EndpointRequest>(_ endpoint: Endpoint,
                     completionHandler: @escaping (Result<Endpoint.ResponseType, Error>) -> Void) {
        do {
            let request = try endpoint.createURLRequest()
            session.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    completionHandler(.failure(error!))
                    return
                }
                guard let data = data else {
                    completionHandler(.failure(NetworkingError.ResponseDataNotFound))
                    return
                }
                print("FILE: \(#file) FUNCTION: \(#function) REQUEST: \(String(describing: request.url)) RESPONSE: \(String(data: data, encoding: .utf8)!)")
                if let responseData = try? endpoint.decode(data: data) {
                    completionHandler(.success(responseData))
                } else {
                    completionHandler(.failure(NetworkingError.ParseError(responseData: data)))
                }
            }.resume()
        } catch {
            completionHandler(.failure(error))
        }
    }
}
