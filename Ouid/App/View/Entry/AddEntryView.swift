//
//  AddEntryView.swift
//  Ouid
//
//  Created by Kevin Laminto on 30/5/21.
//

import SwiftUI
import Combine

class AddEntryViewDelegate: ObservableObject {
    var didChange = PassthroughSubject<AddEntryViewDelegate, Never>()
    
    var newEntry: Entry! {
        didSet {
            self.didChange.send(self)
        }
    }
}

struct AddEntryView: View {
    @ObservedObject var delegate: AddEntryViewDelegate
    private var dismissAction: (() -> Void)?
    @State private var amount = "0."
    @State private var date = Date()
    @State private var isUsingCurrentDateTime = true
    @State private var isShowingError = false
    @State private var errorMessage = ""
    
    init(delegate: AddEntryViewDelegate, dismissAction: (() -> Void)?) {
        self.delegate = delegate
        self.dismissAction = dismissAction
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    amountTextField
                }
                dateTimePicker
            }
            .onTapGesture {
                self.endEditing(true)
            }
            .navigationBarTitle("Add an Entry", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        self.dismissAction!()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        if let amount = Double(amount) {
                            delegate.newEntry = .init(date: date, measurement: .init(value: amount, unit: .grams))
                            self.dismissAction!()
                        } else {
                            errorMessage = "Unable to create an entry, please double check your input."
                            isShowingError = true
                        }
                    }
                }
            }
            .alert(isPresented: $isShowingError) {
                Alert(title: Text("Something went wrong."), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

extension AddEntryView {
    
    private var amountTextField: some View {
        HStack {
            Text("Amount")
            TextField("0.0", text: $amount)
                .keyboardType(.decimalPad)
            Text("G")
                .foregroundColor(.secondary)
                .font(.caption)
        }
    }
    
    private var dateTimePicker: some View {
        return (
            Section {
                Toggle("Use current date and time", isOn: $isUsingCurrentDateTime)
                if !isUsingCurrentDateTime {
                    DatePicker("Date", selection: $date, in: ...Date(), displayedComponents: .date)
                    DatePicker("Time", selection: $date, in: ...Date(), displayedComponents: .hourAndMinute)
                }
            }
        )
    }
}

extension View {
    func endEditing(_ force: Bool) {
        UIApplication.shared.windows.forEach { $0.endEditing(force)}
    }
}
