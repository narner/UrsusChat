//
//  InviteUpdate.swift
//  Ursus Chat
//
//  Created by Daniel Clelland on 6/07/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation
import UrsusAirlock

enum InviteUpdate: Decodable {
    
    case initial(InviteUpdateInitial)
    case create(InviteUpdateCreate)
    case delete(InviteUpdateDelete)
    case invite(InviteUpdateInvite)
    case accepted(InviteUpdateAccepted)
    case decline(InviteUpdateDecline)
    
    enum CodingKeys: String, CodingKey {
        
        case initial
        case create
        case delete
        case invite
        case accepted
        case decline
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch Set(container.allKeys) {
        case [.initial]:
            self = .initial(try container.decode(InviteUpdateInitial.self, forKey: .initial))
        case [.create]:
            self = .create(try container.decode(InviteUpdateCreate.self, forKey: .create))
        case [.delete]:
            self = .delete(try container.decode(InviteUpdateDelete.self, forKey: .delete))
        case [.invite]:
            self = .invite(try container.decode(InviteUpdateInvite.self, forKey: .invite))
        case [.accepted]:
            self = .accepted(try container.decode(InviteUpdateAccepted.self, forKey: .accepted))
        case [.decline]:
            self = .decline(try container.decode(InviteUpdateDecline.self, forKey: .decline))
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode \(type(of: self)); available keys: \(container.allKeys)"))
        }
    }
    
}

typealias InviteUpdateInitial = Invites

struct InviteUpdateCreate: Decodable {
    
    var path: Path
    
}

struct InviteUpdateDelete: Decodable {
    
    var path: Path
    
}

struct InviteUpdateInvite: Decodable {
    
    var path: Path
    var uid: String
    var invite: Invite
    
}

struct InviteUpdateAccepted: Decodable {
    
    var path: Path
    var uid: String
    
}

struct InviteUpdateDecline: Decodable {
    
    var path: Path
    var uid: String
    
}

typealias Invites = [Path: AppInvites]

typealias AppInvites = [Path: Invite]

struct Invite: Decodable {
    
    var ship: Ship
    var app: App
    var path: Path
    var recipient: Ship
    var text: String
    
}
