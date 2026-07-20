//
//  OracleMessage.swift
//  HadexGate
//

import Foundation

struct OracleMessage: Identifiable, Hashable {
    enum Role {
        case seeker   // the user
        case oracle   // the guide
    }

    var id = UUID()
    let role: Role
    var text: String
    var date = Date()
    var isThinking = false
}
