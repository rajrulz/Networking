//
//  Endpoint.swift
//  Networking
//
//  Created by Rajneesh Biswal on 23/11/22.
//

import Foundation

public enum Environment {
    case Production
    case Uat
    case Preprod
    

    public var baseURL: String {
        switch self {
        case .Production:
            return "https://api.github.com/"
        case .Preprod:
            return "https://api.github.com/"
        case .Uat:
            return "https://api.github.com/"
        }
    }
}

enum EndpointError: Error {
    case incorrectURL(urlStr: String)
}

public enum HTTPMethod: String {
    case POST
    case GET
}

public protocol EndpointRequest {
    associatedtype ResponseType: Codable

    // required Params
    var baseURL: String { get }
    var method: HTTPMethod { get }

    // optional Params
    var headers: [String: String]? { get }
    var body: Data? { get }
    var queryParams: [String: String]? { get }

    func createURLRequest() throws -> URLRequest
    func decode(data: Data) throws -> ResponseType
}

extension EndpointRequest {
    public func createURLRequest() throws -> URLRequest {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw EndpointError.incorrectURL(urlStr: baseURL)
        }
        if let queryPararms = queryParams {
            var queryItems: [URLQueryItem] = []
            queryPararms.forEach { queryItems.append(.init(name: $0, value: $1)) }
            urlComponents.queryItems = queryItems
        }
        var request = URLRequest(url: urlComponents.url!)
        headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        request.httpMethod = self.method.rawValue.uppercased()
        request.httpBody = body
        return request
    }

    public func decode(data: Data) throws -> ResponseType {
        let response = try JSONDecoder().decode(ResponseType.self, from: data)
        return response
    }
}

public struct NetworkRequest<ResponseType: Codable>: EndpointRequest {
    public var baseURL: String
    public var method: HTTPMethod
    public var headers: [String : String]?
    public var body: Data?
    public var queryParams: [String : String]?
}
