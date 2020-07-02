//
//  SessionAction.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 30/06/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftThunk
import Ursus

protocol SessionAction: Action {
    
    func reduce(_ state: inout SessionState) throws
    
}

enum SessionActionError: Error {
    
    case alreadyLoggedIn
    case alreadyLoggedOut
    
}

func sessionThunk(url: URL, code: Code) -> Thunk<AppState> {
    return Thunk<AppState> { dispatch, getState in
        let client = Ursus(url: url, code: code)
        client.loginRequest { ship in
            dispatch(SessionLoginAction(client: client))
            dispatch(subscriptionThunk(client: client, ship: ship))
        }.response { response in
            if let error = response.error {
                dispatch(AppErrorAction(error: error))
            }
        }
    }

}

struct SessionLoginAction: SessionAction {
    
    var client: Ursus
    
    func reduce(_ state: inout SessionState) throws {
        switch state {
        case .unauthenticated:
            state = .authenticated(client: client)
        case .authenticated:
            throw SessionActionError.alreadyLoggedIn
        }
    }
    
}

struct SessionLogoutAction: SessionAction {
    
    func reduce(_ state: inout SessionState) throws {
        switch state {
        case .unauthenticated:
            throw SessionActionError.alreadyLoggedOut
        case .authenticated:
            state = .unauthenticated()
        }
    }
    
}
