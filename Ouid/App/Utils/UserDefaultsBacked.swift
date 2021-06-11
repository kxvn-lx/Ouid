//
//  UserDefaultsBacked.swift
//  Ouid
//
//  Created by Kevin Laminto on 11/6/21.
//

import Foundation

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}


@propertyWrapper struct UserDefaultsBacked<Value> {
    enum Key: String {
        case chartStyle
    }
    
    var wrappedValue: Value {
        get {
            let value = storage.value(forKey: key.rawValue) as? Value
            return value ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                storage.removeObject(forKey: key.rawValue)
            } else {
                storage.setValue(newValue, forKey: key.rawValue)
            }
        }
    }

    private let key: Key
    private let defaultValue: Value
    private let storage: UserDefaults

    init(wrappedValue defaultValue: Value,
         key: Key,
         storage: UserDefaults = .standard) {
        self.defaultValue = defaultValue
        self.key = key
        self.storage = storage
    }
}

extension UserDefaultsBacked where Value: ExpressibleByNilLiteral {
    init(key: Key, storage: UserDefaults = .standard) {
        self.init(wrappedValue: nil, key: key, storage: storage)
    }
}
