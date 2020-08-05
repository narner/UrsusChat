//
//  AppAction.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 30/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift

protocol AppAction: Action {
    
    func reduce(_ state: inout AppState) throws
    
}

struct AppConnectAction: AppAction {
    
    func reduce(_ state: inout AppState) throws {
        
    }
    
}

struct AppBackgroundAction: AppAction {
    
    func reduce(_ state: inout AppState) throws {
        guard case .authenticated(let airlock, _) = state.session else {
            return
        }
        
        airlock.disconnect()
    }
    
}

struct AppForegroundAction: AppAction {
    
    func reduce(_ state: inout AppState) throws {
        guard case .authenticated(let airlock, _) = state.session else {
            return
        }
        
        airlock.connect()
    }
    
}

struct AppDisconnectAction: AppAction {
    
    func reduce(_ state: inout AppState) throws {
        state.session = .unauthenticated
    }
    
}

struct AppErrorAction: AppAction {
    
    var error: Error
    
    func reduce(_ state: inout AppState) throws {
        state.errors.append(error)
    }
    
}

struct AppDismissErrorAction: AppAction {
    
    func reduce(_ state: inout AppState) throws {
        guard state.errors.isEmpty == false else {
            return
        }
        
        state.errors.removeLast()
    }
    
}
