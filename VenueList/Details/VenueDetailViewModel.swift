//
//  VenueDetailViewModel.swift
//  VenueList
//
//  Created by John Paul Manoza (NCS) on 2/11/25.
//

import Foundation
import Combine

class VenueDetailViewModel: ObservableObject {
    @Published var ticketDetail: TicketDetail?
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    // declare other hard coded strings here
    // so other modules can re-create this vm and inject the ff values
    let strLoadingTicket = "Loading Ticket ..."
    
    private var cancellables: Set<AnyCancellable> = []
    
    @MainActor
    func loadTicketDetails(venueCode: String, barCode: String) {
        guard let urlRequest = getScanTicketUrlRequest(venueCode, barCode),
            !isLoading else {
            return
        }
        isLoading = true

        let session = getDefaultUrlSession()
        session.dataTaskPublisher(for: urlRequest)
            .map { $0.data }
            .decode(type: TicketDetail.self, decoder: JSONDecoder())
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
            receiveValue: { [weak self] response in
                self?.ticketDetail = response
            }
            .store(in: &cancellables)
    }
    
    private func getScanTicketUrlRequest(_ venueCode: String, _ barcode: String) -> URLRequest? {
        guard let url = URL(string:
            "https://ignition.qa.ticketek.net/venues/\(venueCode)/pax/entry/scan"
        ) else { return nil }
        
        // Define parameters
        let parameters: [String: Any] = [
            "barcode": barcode
        ]

        let jsonData = (try? JSONSerialization.data(withJSONObject: parameters)) ?? Data("{}".utf8)
        
        // Create urlrquest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        return request
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

