//
//  Observable.swift
//  TouristSites
//
//  Created by littlema on 2019/10/30.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

class Observable<T> {
    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.valueChanged?(self.value)
            }
        }
    }
    
    private var valueChanged: ((T) -> Void)?
    
    init(value: T) {
        self.value = value
    }
    
    func addObserver(initial: Bool = false, onChange: ((T) -> Void)?) {
        valueChanged = onChange
        if initial {
            valueChanged?(value)
        }
    }
    
    func removeObserver(onChange: ((T) -> Void)?) {
        valueChanged = nil
    }

}
