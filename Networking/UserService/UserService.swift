//
//  UserService.swift
//  Networking
//
//  Created by Rajneesh Biswal on 23/11/22.
//

import Foundation

protocol UserService {
    func getUsers(forEndpointPath path: String,
                  queryParams: [String: String],
                  completionHandler: @escaping(Result<[User], Error>) -> Void)
}

class UsersServiceClient: UserService {
    private var environment: Environment

    init(environment: Environment) {
        self.environment = environment
    }

    func getUsers(forEndpointPath path: String,
                  queryParams: [String: String],
                  completionHandler: @escaping (Result<[User], Error>) -> Void) {
        let urlStr = environment.baseURL + path
        HttpService().makeNetworkRequest(NetworkRequest<[User]>(baseURL: urlStr,
                                                     method: .GET,
                                                     headers: nil,
                                                     body: nil,
                                                     queryParams: queryParams)) { result in
            switch result {
            case .success(let users):
                completionHandler(.success(users))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
