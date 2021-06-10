//
//  SettingsView.swift
//  Ouid
//
//  Created by Kevin Laminto on 10/6/21.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Customisation")) {
                    NavigationLink(
                        destination: ChartColourPickerView(),
                        label: {
                            Text("Bar chart colours")
                        })
                }
            }
            .navigationBarTitle(Text("Settings"))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
