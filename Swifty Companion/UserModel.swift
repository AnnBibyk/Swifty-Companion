//
//  UserModel.swift
//  Swifty Companion
//
//  Created by Anna Bibyk on 22.02.2020.
//  Copyright © 2020 Anna Bibyk. All rights reserved.
//

import Foundation

// MARK: - User
struct User: Codable {
    let email, login: String
    let phone, displayname: String
    let imageURL: String
    let staff: Bool
    let correctionPoint: Int
    let poolMonth, poolYear: String
    let wallet: Int
    let cursusUsers: [CursusUser]
    let projectsUsers: [ProjectsUser]

    enum CodingKeys: String, CodingKey {
        case email, login
        case phone, displayname
        case imageURL = "image_url"
        case staff = "staff?"
        case correctionPoint = "correction_point"
        case poolMonth = "pool_month"
        case poolYear = "pool_year"
        case wallet
        case cursusUsers = "cursus_users"
        case projectsUsers = "projects_users"
    }
}

// MARK: - CursusUser
struct CursusUser: Codable {
    let grade: String?
    let level: Double
    let skills: [Skill]
}

// MARK: - Skill
struct Skill: Codable {
    let name: String
    let level: Double
}

// MARK: - Cursus
struct Cursus: Codable {
    let id: Int
    let name: String
    let parent_id : Int?
    let slug : String?
}

// MARK: - ProjectsUser
struct ProjectsUser: Codable {
    let finalMark: Int?
    let status: Status
    let validated: Bool?
    let project: Cursus

    enum CodingKeys: String, CodingKey {
        case finalMark = "final_mark"
        case status
        case validated = "validated?"
        case project
    }
}

enum Status: String, Codable {
    case creatingGroup = "creating_group"
    case finished = "finished"
    case inProgress = "in_progress"
    case parent = "parent"
    case searchingAGroup = "searching_a_group"
}

