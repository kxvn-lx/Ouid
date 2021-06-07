//
//  AddEntryView.swift
//  Ouid
//
//  Created by Kevin Laminto on 30/5/21.
//

import SwiftUI
import Combine

/// Publisher to read keyboard changes.
protocol KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> { get }
}

extension KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },
            
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .eraseToAnyPublisher()
    }
}

class AddEntryViewDelegate: ObservableObject {
    var didChange = PassthroughSubject<AddEntryViewDelegate, Never>()
    
    var newEntry: Entry? {
        didSet {
            self.didChange.send(self)
        }
    }
}

struct AddEntryView: View, KeyboardReadable {
    @Environment(\.presentationMode) private var presentationMode
    @State private var amount = ""
    @State private var date = Date()
    @State private var isUsingCurrentDateTime = true
    @State private var isShowingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    amountTextField
                        .onReceive(keyboardPublisher, perform: { newValue in
                            if newValue && amount == "" {
                                amount = "0."
                                return
                            }
                            
                            if amount == "0." {
                                amount = ""
                                return
                            }
                        })
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
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        if let amount = Double(amount) {
                            SaveEngine.shared.save(.init(date: date, measurement: .init(value: amount, unit: .grams)), newEntries: nil)
                            self.presentationMode.wrappedValue.dismiss()
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
        }
        .font(.system(.body, design: .rounded))
    }
    
    private var dateTimePicker: some View {
        return (
            Section(footer: Text("You can only select current or past date.")) {
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
