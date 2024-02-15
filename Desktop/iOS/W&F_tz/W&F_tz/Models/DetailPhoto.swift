//
//  DetailPhoto.swift
//  W&F_tz
//
//  Created by Диас Мурзагалиев on 15.02.2024.
//

import Foundation

struct DetailPhoto: Decodable {
    let id: String
    let created_at: String
    let width: Int
    let height: Int
    let downloads: Int?
    let location: Location?
    let urls: [URLType.RawValue : String]
    let user: User
}

struct Location: Decodable {
    let city: String?
    let country: String?
}

enum URLType: String {
    case raw
    case full
    case regular
    case small
    case thumb
}

struct User: Decodable {
    let name: String
}
