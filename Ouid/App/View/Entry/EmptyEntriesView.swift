//
//  EmptyEntriesView.swift
//  Ouid
//
//  Created by Kevin Laminto on 30/5/21.
//

import SwiftUI

struct EmptyEntriesView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("🌿")
                .font(.system(size: 50))
            Text("Press the + icon to add a  new entry.")
                .foregroundColor(.secondary)
        }
    }
}

struct EmptyEntriesView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyEntriesView()
    }
}
