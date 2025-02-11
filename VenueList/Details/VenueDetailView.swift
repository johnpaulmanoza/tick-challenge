//
//  VenueDetailView.swift
//  VenueList
//
//  Created by John Paul Manoza (NCS) on 2/11/25.
//

import SwiftUI

struct VenueDetailView: View {
    var venue: Venue?
    
    @StateObject var viewModel = VenueDetailViewModel()
    @State private var scannedBarcode: String? = nil
        
    var body: some View {
        ZStack {
            if let barcode = scannedBarcode {
                if let detail = viewModel.ticketDetail, !viewModel.isLoading {
                    ticketDetails(detail, barcode)
                } else {
                    ticketLoader(value: barcode)
                }
            } else {
                BarcodeScannerView { barcode in
                    scannedBarcode = barcode
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
        .onChange(of: scannedBarcode) { _, barcode in
            guard let barCode = barcode, let venueCode = venue?.code else {
                return
            }
            viewModel.loadTicketDetails(venueCode: venueCode, barCode: barCode)
        }
    }
    
    private func ticketLoader(value: String) -> some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2)
                .frame(maxWidth: .infinity, maxHeight: 40)
            Text(viewModel.strLoadingTicket)
                .font(.title)
                .bold()
            Text(value)
                .font(.headline)
                .foregroundColor(.gray)
        }
    }
    
    private func ticketDetails(_ detail: TicketDetail, _ barCode: String) -> some View {
        VStack(spacing: 20) {
            let icon = detail.grantEntry ? "checkmark.circle.fill" : "xmark.circle.fill"
            let color: Color = detail.grantEntry ? .green : .red
            Image(systemName: icon)
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(color)
            Text(detail.action)
                .font(.title)
                .bold()
            Text(barCode)
                .font(.headline)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    VenueDetailView()
}
