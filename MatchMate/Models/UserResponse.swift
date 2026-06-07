//
//  UserResponse.swift
//  MatchMate
//
//  Created by Apple on 07/06/26.
//

import Foundation

struct UserResponse: Codable {
    let results: [User]
}

struct User: Codable, Identifiable {

    var id: String {
        login.uuid
    }

    let name: Name
    let location: Location
    let dob: DOB
    let picture: Picture
    let login: Login
    var status: MatchStatus = .pending

    var fullName: String {
        "\(name.first) \(name.last)"
    }

    var imageURL: String {
        picture.large
    }

    enum CodingKeys: String, CodingKey {
        case name
        case location
        case dob
        case picture
        case login
    }
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
}

struct Location: Codable {
    let city: String
    let state: String
}

struct DOB: Codable {
    let age: Int
}

struct Picture: Codable {
    let large: String
}

struct Login: Codable {
    let uuid: String
}
