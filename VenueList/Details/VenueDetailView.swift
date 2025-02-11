//
//  VenueDetailView.swift
//  VenueList
//
//  Created by John Paul Manoza (NCS) on 2/11/25.
//

import SwiftUI

struct VenueDetailView: View {
    var venue: Venue?
    
    @State private var scannedBarcode: String? = nil
        
    var body: some View {
        ZStack {
            if let barcode = scannedBarcode {
                ticketLoader(value: barcode)
            } else {
                BarcodeScannerView { barcode in
                    scannedBarcode = barcode
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    private func ticketLoader(value: String) -> some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2)
                .frame(maxWidth: .infinity, maxHeight: 40)
            Text("Loading Ticket")
                .font(.title)
                .bold()
            Text(value)
                .font(.headline)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    VenueDetailView()
}
