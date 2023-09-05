//
//  IntroView.swift
//  Habit_Flow_V2
//
//  Created by Marc Bachmann on 04.08.23.
//

import SwiftUI

struct IntroView: View {
    @State private var pageIndex = 0
    private let pages: [Page] = Page.samplePages
    private let dotAppearance = UIPageControl.appearance()
    private let notificationManager = NotificationManager()
    
    var body: some View {
        TabView(selection: $pageIndex) {
            ForEach(pages) { page in
                VStack {
                    Spacer()
                    PageView(page: page)
                    Spacer()
                    Spacer()
                    if(page == pages.last) {
                        Button("Starte durch!", action: goToZero)
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .frame(height: 50)
                            .frame(maxWidth: 180)
                            .background(Color.orange)
                            .cornerRadius(32)
                        
                    }else if(page.tag == 2){
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
                    }else {
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
                .tag(page.tag)
            }
        }
        .animation(.easeInOut, value: pageIndex)
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
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
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
