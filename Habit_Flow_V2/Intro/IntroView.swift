//
//  IntroView.swift
//  Habit_Flow_V2
//
//  Created by Marc Bachmann on 04.08.23.
//

import SwiftUI

struct IntroView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var pageIndex = 0
    @StateObject var userViewModel: UserViewModel
    private let pages: [Page] = Page.samplePages
    private let dotAppearance = UIPageControl.appearance()
    private let notificationManager = NotificationManager()
    
    @State private var selectedImage: UIImage?
    @State private var showImagePicker: Bool = false
    
    @State var textFieldInput: String = ""
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    
    var body: some View {
        TabView(selection: $pageIndex) {
            ForEach(pages) { page in
                VStack {
                    Spacer()
                    PageView(page: page)
                    
                    if(page == pages.last) {
                        Spacer()
                        Spacer()
                        Button("Starte durch!", action: toggleFirstStarted)
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .frame(height: 50)
                            .frame(maxWidth: 180)
                            .background(Color.orange)
                            .cornerRadius(32)
                        
                    }else if(page.tag == 2){
                        Spacer()
                        Spacer()
                        HStack(spacing: 20) {
                            Button("erlauben", action: setNotifications)
                                .foregroundColor(.white)
                            
                                .fontWeight(.semibold)
                                .frame(height: 50)
                                .frame(maxWidth: 140)
                                .background(Color.orange)
                                .cornerRadius(32)
                            
                            
                            Button("jetzt nicht", action: incrementPage)
                                .foregroundColor(.white)
                            
                                .fontWeight(.semibold)
                                .frame(height: 50)
                                .frame(maxWidth: 140)
                                .background(Color(UIColor.systemGray5))
                                .cornerRadius(32)
                        }
                    }else if(page.tag == 3){ //profil erstellen
                        Spacer()
                        TextField("Name", text: $textFieldInput)
                            .padding(.horizontal)
                            .frame(height: 41)
                            .background(Color(UIColor.systemGray2))
                            .cornerRadius(12)
                            .padding()
                        
                        HStack {

                            
                            Button("Profilbild auswählen", action: {
                                // Handler zum Auswählen eines Profilbildes
                                showImagePicker = true
                            })
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .frame(height: 50)
                            .frame(maxWidth: 180)
                            .background(Color.orange)
                            .cornerRadius(32)
                            .padding()
                            
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.gray)
                            }

                        }
                        

                        Spacer()
                        
                        Button("Weiter", action: incrementPageProfile)
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .frame(height: 50)
                            .frame(maxWidth: 180)
                            .background(Color.orange)
                            .cornerRadius(32)
                    }else {
                        Spacer()
                        Spacer()
                        Button("Weiter", action: incrementPage)
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .frame(height: 50)
                            .frame(maxWidth: 180)
                            .background(Color.orange)
                            .cornerRadius(32)
                    }
                    Spacer()
                }
                .sheet(isPresented: $showImagePicker, content: {
                    ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
                })
                .tag(page.tag)
                
                
            }
        }
        .animation(.easeInOut, value: pageIndex)
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        .alert(isPresented: $showAlert, content: getAlert)

        .onAppear {
            dotAppearance.currentPageIndicatorTintColor = .orange
            dotAppearance.pageIndicatorTintColor = .gray
        }
    }
    
    func incrementPage() {
        pageIndex += 1
    }
    
    func goToZero() {
        pageIndex = 0
    }
    
    func setNotifications() {
        notificationManager.requestAuthorization()
        incrementPage()
    }
    
    func toggleFirstStarted() {
        userViewModel.toggleFirstStarted()
    }
    
    func textIsAppropiate() -> Bool {
        if textFieldInput.count < 1 {
            alertTitle = "Gebe noch deinen Namen ein"
            showAlert.toggle()
            return false
        }
        return true
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
    }
    
    func incrementPageProfile() {
        if(textIsAppropiate()) {
            userViewModel.user.userName = textFieldInput
            presentationMode.wrappedValue.dismiss()
            pageIndex += 1
        }
    }
    
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView(userViewModel: UserViewModel())
    }
}
