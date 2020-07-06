//
//  AppThunk.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 7/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import ReSwiftThunk
import Ursus

typealias AppThunk = Thunk<AppState>

extension AppThunk {
    
    static func startSession(url: URL, code: Code) -> Thunk<AppState> {
        return Thunk<AppState> { dispatch, getState in
            let client = Ursus(url: url, code: code)
            client.loginRequest { ship in
                dispatch(SessionLoginAction(client: client))
                dispatch(AppThunk.startSubscription(client: client, ship: ship))
            }.response { response in
                if let error = response.error {
                    dispatch(AppErrorAction(error: error))
                }
            }
        }
    }

    static func startSubscription(client: Ursus, ship: Ship) -> Thunk<AppState> {
        return Thunk<AppState> { dispatch, getState in
            client.chatView(ship: ship).primary { event in
                dispatch(SubscriptionEventAction(event: event))
            }.response { response in
                client.chatHook(ship: ship).synced { event in
                    dispatch(SubscriptionEventAction(event: event))
                }
                client.inviteStore(ship: ship).all { event in
                    dispatch(SubscriptionEventAction(event: event))
                }
                client.permissionStore(ship: ship).all { event in
                    dispatch(SubscriptionEventAction(event: event))
                }
                client.contactView(ship: ship).primary { event in
                    dispatch(SubscriptionEventAction(event: event))
                }
                client.metadataStore(ship: ship).appName(app: "chat") { event in
                    dispatch(SubscriptionEventAction(event: event))
                }
                client.metadataStore(ship: ship).appName(app: "contacts") { event in
                    dispatch(SubscriptionEventAction(event: event))
                }
            }
        }
    }
    
}
