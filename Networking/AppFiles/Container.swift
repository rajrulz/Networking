//
//  Container.swift
//  Networking
//
//  Created by Rajneesh Biswal on 17/03/23.
//

import Foundation

public final class Container {
    private var registery: [String: Any] = [:]
    public func register<Interface>(_ objectType: Interface.Type, provider: @escaping () -> Interface) {
        if !checkIfAlreadyRegistered(identifier(objectType)) {
            registery[identifier(objectType)] = provider()
        }
    }

    public func register<Interface>(_ objectType: Interface.Type, provider: Interface) {
        if !checkIfAlreadyRegistered(identifier(objectType)) {
            registery[identifier(objectType)] = provider
        }
    }

    public func register<Interface>(_ objectType: Interface.Type, provider: @escaping (Container) -> Interface) {
        if !checkIfAlreadyRegistered(identifier(objectType)) {
            registery[identifier(objectType)] = provider(self)
        }
    }

    private func identifier<Interface>(_ objectType: Interface.Type) -> String {
        String(describing: objectType)
    }

    private func checkIfAlreadyRegistered(_ identifier: String) -> Bool {
        guard registery[identifier] == nil else {
            print("\(identifier) already registered")
            return true
        }
        return false
    }

    public func getIfResgistered<Interface>(_ type: Interface.Type = Interface.self) -> Interface {
        registery[String(describing: type)] as! Interface
    }

    public func get<Interface>(_ type: Interface.Type = Interface.self) -> Interface? {
        guard let object = registery[String(describing: type)] as? Interface else { return nil }
        return object
    }
}

#if DEBUG
extension Container {
    struct TestHooks {
        private var target: Container
        init( target : Container) {
            self.target = target
        }

        public func checkIfAlreadyRegistered(_ identifier: String) -> Bool {
            target.checkIfAlreadyRegistered(identifier)
        }
    
        public func identifier<Interface>(_ objectType: Interface.Type) -> String {
            target.identifier(objectType)
        }
    }
    var testHooks: TestHooks {
        TestHooks(target: self)
    }

}
#endif
