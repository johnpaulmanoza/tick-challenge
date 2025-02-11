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
                    .navigationTitle(viewModel.strScreenTitle)
            }
        }
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
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(viewModel.venues, id: \.code) { venue in
                    NavigationLink {
                        VenueDetailView(venue: venue)
                    } label: {
                        venueLink(venue)
                    }
                }
            }
        }
    }
    
    private func venueLink(_ item: Venue) -> some View {
        VStack(alignment: .leading) {
            Text(item.name)
                .font(.title3)
            Text(item.address)
                .font(.subheadline)
        }
    }
}
