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
}

struct PaxLocation: Codable {
    let name: String
    let gates: [Gate]
}

struct Gate: Codable {
    let name: String
}

struct VenueCurrLocation: Identifiable, Equatable {
    var id = UUID()
    let lat: Double
    let lng: Double
}
