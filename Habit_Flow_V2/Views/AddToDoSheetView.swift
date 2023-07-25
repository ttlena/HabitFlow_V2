//
//  AddToDoSheetView.swift
//  Habit_Flow_V2
//
//  Created by Marc Bachmann on 05.07.23.
//

import SwiftUI

struct AddToDoSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var toDosViewModel: ToDosViewModel
    
    @State var textFieldText: String=""
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    
    let fieldBackground = Color(red: 84, green: 84, blue:84)
    
    var body: some View {
        VStack {
            Text("Neues ToDo")
                .font(.title)
                .fontWeight(.heavy)
                .padding(0.0)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            
            TextField("Titel", text: $textFieldText)
                .padding(.horizontal)
                .frame(height: 41)
                .background(Color(UIColor.systemGray2))
                .cornerRadius(12)
            Button(action: saveButtonPressed, label: {
                Text("Speichern")
                    .foregroundColor(.white)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(32)
                    .padding([.horizontal], 70)
            })
            .frame(maxHeight: .infinity, alignment: .bottom)
            
        }
        .padding(39)
        .alert(isPresented: $showAlert, content: getAlert)
    }
    
    func saveButtonPressed() {
        if textIsAppropiate() {            
            toDosViewModel.addItem(title: textFieldText)
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func textIsAppropiate() -> Bool {
        if textFieldText.count < 3 {
            alertTitle = "Der Titel sollte mindestens eine Länge von 3 Zeichen haben!"
            showAlert.toggle()
            return false
        }
        return true
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
    }
    
    
    
}

struct AddToDoSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AddToDoSheetView(toDosViewModel:ToDosViewModel())
    }
}
