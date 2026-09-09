//
//  LoadingStateView.swift
//  MovieApp
//
//  Created by Eminov Togrul Punhan on 04.09.26.
//

import SwiftUI

struct LoadingStateView: View {
    var message: String = "loading movies..."
    var body: some View {
        VStack(spacing: 16) {
            ProgressView().controlSize(.large)
            Text(message).font(.subheadline).foregroundStyle(.secondary)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)

    }
}
