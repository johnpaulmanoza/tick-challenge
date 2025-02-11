//
//  VenueViewModel.swift
//  VenueList
//
//  Created by John Paul Manoza (NCS) on 2/11/25.
//

import Foundation
import Combine

class VenueListViewModel: ObservableObject {
    @Published var venues: [Venue] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    // declare other hard coded strings here
    // so other modules can re-create this vm and inject the ff values
    let strLocationError = "Failed to get your current location"
    let strScreenTitle = "List of Venues"
    let strLoadingLocation = "Requesting Location..."
    
    private var cancellables: Set<AnyCancellable> = []
    
    @MainActor
    func loadData(_ location: VenueCurrLocation) {
        guard !isLoading, let url = getVenueUrl(location) else {
            return
        }
        isLoading = true
        let session = getDefaultUrlSession()
        session.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: VenuesResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                switch status {
                case .finished:
                    self?.isLoading = false
                case .failure(let err):
                    self?.isLoading = false
                    self?.error = err
                }
            }
            receiveValue: { [weak self] values in
                 self?.venues = values.venues
            }
            .store(in: &cancellables)
    }
    
    private func getVenueUrl(_ location: VenueCurrLocation) -> URL? {
        return URL(string:
            "https://ignition.qa.ticketek.net/venues/?latitude=\(location.lat)&longitude=\(location.lng)"
        )
    }
    
    private func getDefaultUrlSession() -> URLSession {
        let config = URLSessionConfiguration.default
        // TODO: Move this into a more secure location
        config.httpAdditionalHeaders = [
            "Content-Type": "application/json",
            "Accept-Language": "en",
            "X-API-Key": "TEq5Mddna23xSNsoDeYt8aP02BJHrvoa6X07nEuD",
            "Authorization": "Basic Yhd9X=38D88!"
        ]
        return URLSession(configuration: config)
    }
}
