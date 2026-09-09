//
//  SectionHeaderView.swift
//  MovieApp
//
//  Created by Eminov Togrul Punhan on 04.09.26.
//

import SwiftUI

struct SectionHeaderView: View {
    let title: String
    let category: MovieCategory
    var body: some View {
        HStack {
            Text(title).font(.title3).fontWeight(.bold)
            Spacer()
            NavigationLink(value:AppRoute.movieList(category)) {
                HStack(spacing: 4) {
                    Text("See all")
                    Image(systemName: "chevron.right").font(.caption)
                }.font(.subheadline).fontWeight(.semibold).foregroundStyle(
                    .tint
                )
            }
        }
    }
}
