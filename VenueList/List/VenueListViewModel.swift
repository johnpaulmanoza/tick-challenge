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
    
    private var cancellables: Set<AnyCancellable> = []
    
    @MainActor
    func loadData() {
        guard !isLoading else {
            return
        }
        
        guard let url = URL(string: "") else {
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: VenuesResponse.self, decoder: JSONDecoder())
            .sink { [weak self] status in
                switch status {
                case .finished:
                    self?.isLoading = false
                case .failure(let err):
                    self?.isLoading = false
                    self?.error = err
                }
            } receiveValue: { [weak self] values in
                self?.venues = values.venues
            }
            .store(in: &cancellables)
    }
}
