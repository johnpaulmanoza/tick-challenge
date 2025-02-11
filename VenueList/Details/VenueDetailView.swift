//
//  VenueDetailView.swift
//  VenueList
//
//  Created by John Paul Manoza (NCS) on 2/11/25.
//

import SwiftUI

struct VenueDetailView: View {
    var venue: Venue?
    
    var body: some View {
        VStack(alignment: .center) {
//            AsyncImage(url: URL(string: user?.avatar ?? "")) { image in
//                image.image?.resizable().aspectRatio(contentMode: .fill)
//            }.frame(width: 150, height: 150)
            
            Text(venue?.name ?? "")
                .foregroundStyle(.black)
                .fontWeight(.bold)
            Text(venue?.address ?? "")
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    VenueDetailView()
}
