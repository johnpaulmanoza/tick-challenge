//
//  VenueListView.swift
//  VenueList
//
//  Created by John Paul Manoza (NCS) on 2/11/25.
//

import SwiftUI

struct VenueListView: View {
    @StateObject var viewModel = VenueListViewModel()
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        NavigationView {
            if locationManager.currentLocation == nil {
                locationView()
            } else {
                listView()
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2) // Makes the spinner larger if desired
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.opacity(0.7)) // Optional: adds a semi-transparent background
            }
        }
        .navigationTitle(viewModel.strScreenTitle)
        .onAppear {
            locationManager.requestLocation()
        }
        .onChange(of: locationManager.currentLocation) { _, newLocation in
            guard let location = newLocation else {
                return
            }
            viewModel.loadData(location)
        }
    }
    
    private func locationView() -> some View {
        VStack {
            if let error = locationManager.errorMessage, 
                !locationManager.isLoadingLocation {
                VStack {
                    Text(viewModel.strLocationError)
                        .font(.title2)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Text(error)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
            } 
            
            if locationManager.isLoadingLocation {
                Text(viewModel.strLoadingLocation)
                    .font(.title2)
                    .padding()
            }
        }
    }
    
    private func listView() -> some View {
        VStack {
            List(viewModel.venues, id: \.code) { venue in
                NavigationLink {
                    VenueDetailView(venue: venue)
                } label: {
                    venueLink(venue)
                }
            }
        }
    }
    
    private func venueLink(_ item: Venue) -> some View {
        VStack(alignment: .leading) {
            Text(item.name)
                .font(.title3)
                .foregroundStyle(.black)
            Text(item.address)
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
    }
}
