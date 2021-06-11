//
//  SettingsView.swift
//  Ouid
//
//  Created by Kevin Laminto on 10/6/21.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Customisation")) {
                    NavigationLink(
                        destination: ChartColourPickerView(),
                        label: {
                            Text("Bar chart")
                        })
                }
            }
            .navigationBarTitle(Text("Settings"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}