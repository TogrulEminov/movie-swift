//
//  MovieInfoItemView.swift
//  MovieApp
//
//  Created by Eminov Togrul Punhan on 08.09.26.
//

import SwiftUI

struct MovieInfoItemView: View {
    let icon: String
    let title: String
    let value: String
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon).font(.title3).foregroundStyle(.tint)
            Text(value).font(.subheadline).fontWeight(.semibold)
                .foregroundStyle(.primary).lineLimit(1)
            Text(title).font(.caption).foregroundStyle(.secondary)
        }.frame(maxWidth: .infinity).padding(.vertical, 15)
            .background(AppColors.secondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
}
