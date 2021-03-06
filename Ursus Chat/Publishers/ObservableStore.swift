//
//  ObservableStore.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 1/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift

class ObservableStore<State: StateType>: ObservableObject {
    
    @Published private(set) var state: State
    
    private var store: Store<State>
    
    init(reducer: @escaping Reducer<State>, state: State? = nil, middleware: [Middleware<State>] = [], automaticallySkipsRepeats: Bool = true) {
        self.store = Store(reducer: reducer, state: state, middleware: middleware, automaticallySkipsRepeats: automaticallySkipsRepeats)
        self.state = store.state
        store.subscribe(self)
    }
    
    deinit {
        store.unsubscribe(self)
    }
    
}

extension ObservableStore {
    
    func dispatch(_ action: Action) {
        store.dispatch(action)
    }

    subscript(_ action: Action) -> () -> Void {
        return { [weak self] in
            self?.store.dispatch(action)
        }
    }
    
}

extension ObservableStore: StoreSubscriber {
    
    func newState(state: State) {
        DispatchQueue.main.async {
            self.state = state
        }
    }
    
}
