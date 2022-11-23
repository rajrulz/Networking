//
//  ViewController.swift
//  Networking
//
//  Created by Rajneesh Biswal on 23/11/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        makeNetworkRequest()
    }

    func makeNetworkRequest() {
        let userListNetworkService = UsersServiceClient(environment: .Production)
        userListNetworkService.getUsers(forEndpointPath: "users", queryParams: ["since": "0"]) { response in
            switch response {
            case .success(let users):
                print("********* Got Data from server ******")
                print(users)
            case .failure(let error):
                print(error)
            }
        }
    }
}

