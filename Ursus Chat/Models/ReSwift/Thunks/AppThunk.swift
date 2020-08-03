//
//  AppThunk.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 7/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import KeychainAccess
import ReSwiftThunk
import UrsusAirlock

typealias AppThunk = Thunk<AppState>

//extension AppThunk {
//
//    static func scryClay(airlock: Airlock, ship: Ship) -> AppThunk {
//        return AppThunk { dispatch, getState in
//            airlock.scryRequest(app: "file-server", path: "/clay/base/hash").response { response in
//                switch response.result {
//                case .success(let data):
//                    print("[scry] success:", data ?? Data())
//                case .failure(let error):
//                    print("[scry] failure:", error)
//                }
//            }
//        }
//    }
//
//}

extension AppThunk {
    
    static func startSession(credentials: AirlockCredentials) -> AppThunk {
        return AppThunk { dispatch, getState in
            dispatch(SessionLoginStartAction())
            let airlock = Airlock(credentials: credentials)
            airlock.loginRequest { result in
                switch result {
                case .success(let ship):
                    dispatch(SessionLoginFinishAction(airlock: airlock, ship: ship))
                    dispatch(AppThunk.startSubscription(airlock: airlock, ship: ship))
                    dispatch(AppThunk.setCredentials(credentials))
                case .failure(let error):
                    dispatch(SessionLoginFailureAction())
                    dispatch(AppErrorAction(error: error))
                }
            }
        }
    }

    static func startSubscription(airlock: Airlock, ship: Ship) -> AppThunk {
        return AppThunk { dispatch, getState in
            func handler<Value>(event: SubscribeEvent<Value>) {
                dispatch(SubscriptionEventAction(event: event))
            }
            
            airlock.chatView(ship: ship).primarySubscribeRequest(handler: handler)
            airlock.chatHook(ship: ship).syncedSubscribeRequest(handler: handler)
            airlock.inviteStore(ship: ship).allSubscribeRequest(handler: handler)
            airlock.groupStore(ship: ship).groupsSubscribeRequest(handler: handler)
            airlock.contactView(ship: ship).primarySubscribeRequest(handler: handler)
            airlock.metadataStore(ship: ship).appNameSubscribeRequest(app: "chat", handler: handler)
            airlock.metadataStore(ship: ship).appNameSubscribeRequest(app: "contacts", handler: handler)
        }
    }
    
}

extension AppThunk {
    
    static func endSession() -> AppThunk {
        return AppThunk { dispatch, getState in
            dispatch(SessionLogoutAction())
            dispatch(AppThunk.clearCredentials())
        }
    }
    
}

extension AppThunk {
    
    private static let credentialsKey = "Credentials"
    
    static func getCredentials() -> AppThunk {
        return AppThunk { dispatch, getState in
            do {
                if let credentials = try Keychain.shared.decodeData(AirlockCredentials.self, key: credentialsKey) {
                    dispatch(AppThunk.startSession(credentials: credentials))
                }
            } catch let error {
                dispatch(AppErrorAction(error: error))
            }
        }
    }
    
    static func setCredentials(_ credentials: AirlockCredentials) -> AppThunk {
        return AppThunk { dispatch, getState in
            do {
                try Keychain.shared.encodeData(credentials, key: credentialsKey)
            } catch let error {
                dispatch(AppErrorAction(error: error))
            }
        }
    }
    
    static func clearCredentials() -> AppThunk {
        return AppThunk { dispatch, getState in
            do {
                try Keychain.shared.remove(credentialsKey)
            } catch let error {
                dispatch(AppErrorAction(error: error))
            }
        }
    }
    
}

extension AppThunk {
    
    static func sendRead(path: Path) -> AppThunk {
        return AppThunk { dispatch, getState in
            guard case .authenticated(let airlock, let ship) = getState()?.session else {
                return
            }
            
            airlock.chatStore(ship: ship).readPokeRequest(path: path) { event in
                switch event {
                case .failure(let error):
                    dispatch(AppErrorAction(error: error))
                case .finished:
                    print("[AppThunk.sendRead] Poke finished")
                }
            }.response { response in
                if let error = response.error {
                    dispatch(AppErrorAction(error: error))
                }
            }
        }
    }
    
    static func sendMessage(path: Path, letter: Letter) -> AppThunk {
        return AppThunk { dispatch, getState in
            guard case .authenticated(let airlock, let ship) = getState()?.session else {
                return
            }
            
            let envelope = Envelope(uid: UUID().patUVString, number: 0, author: ship, when: Date(), letter: letter)
            
            dispatch(SubscriptionAddPendingMessageAction(path: path, envelope: envelope))
            
            airlock.chatHook(ship: ship).messagePokeRequest(path: path, envelope: envelope) { event in
                switch event {
                case .failure(let error):
                    dispatch(AppErrorAction(error: error))
                case .finished:
                    print("[AppThunk.sendMessage] Poke finished")
                }
            }.response { response in
                if let error = response.error {
                    dispatch(AppErrorAction(error: error))
                }
            }
        }
    }
    
}

extension AppThunk {
    
    static func getMessages(path: Path, range: ClosedRange<Int>) -> AppThunk {
        return AppThunk { dispatch, getState in
            guard case .authenticated(let airlock, let ship) = getState()?.session else {
                return
            }
            
            airlock.chatView(ship: ship).messagesRequest(path: path, start: range.lowerBound, end: range.upperBound) { result in
                switch result {
                case .success(let response):
                    dispatch(SubscriptionEventAction(event: .update(response)))
                case .failure(let error):
                    dispatch(AppErrorAction(error: error))
                }
            }
        }
    }
    
}
