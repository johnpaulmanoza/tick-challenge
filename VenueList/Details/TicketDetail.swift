//
//  TicketDetail.swift
//  VenueList
//
//  Created by John Paul Manoza (NCS) on 2/11/25.
//

import Foundation

struct TicketDetail: Codable {
    let status: String
    let action: String
    let result: String
    let concession: Int

    enum CodingKeys: String, CodingKey {
        case status, action, result, concession
    }

    // NOTE: Safely handle if one or many props has no value
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decodeIfPresent(String.self, forKey: .status) ?? ""
        self.action = try container.decodeIfPresent(String.self, forKey: .action) ?? ""
        self.result = try container.decodeIfPresent(String.self, forKey: .result) ?? ""
        self.concession = try container.decodeIfPresent(Int.self, forKey: .concession) ?? 0
    }
}
