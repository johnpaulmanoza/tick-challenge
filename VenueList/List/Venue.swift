//
//  Venue.swift
//  VenueList
//
//  Created by John Paul Manoza (NCS) on 2/11/25.
//

import Foundation

struct VenuesResponse: Codable {
    let venues: [Venue]
}

struct Venue: Codable {
    let code: String
    let name: String
    let address: String
    let city: String
    let state: String
    let postcode: String
    let latitude: Double
    let longitude: Double
    let timezone: String
    let paxLocations: [PaxLocation]

    enum CodingKeys: String, CodingKey {
        case code, name, address, city, state, postcode, latitude, longitude, timezone
        case paxLocations = "pax_locations"
    }

    // NOTE: Safely handle if one or many props has no value
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decodeIfPresent(String.self, forKey: .code) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.address = try container.decodeIfPresent(String.self, forKey: .address) ?? ""
        self.city = try container.decodeIfPresent(String.self, forKey: .city) ?? ""
        self.state = try container.decodeIfPresent(String.self, forKey: .state) ?? ""
        self.postcode = try container.decodeIfPresent(String.self, forKey: .postcode) ?? ""
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? 0.0
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? 0.0
        self.timezone = try container.decodeIfPresent(String.self, forKey: .timezone) ?? ""
        self.paxLocations = try container.decodeIfPresent([PaxLocation].self, forKey: .paxLocations) ?? []
    }
}

struct PaxLocation: Codable {
    let name: String
    let gates: [Gate]

    enum CodingKeys: String, CodingKey {
        case name, gates
    }

    // NOTE: Safely handle if one or many props has no value
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.gates = try container.decodeIfPresent([Gate].self, forKey: .gates) ?? []
    }
}

struct Gate: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }

    // NOTE: Safely handle if one or many props has no value
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
}


struct VenueCurrLocation: Identifiable, Equatable {
    var id = UUID()
    let lat: Double
    let lng: Double
}
