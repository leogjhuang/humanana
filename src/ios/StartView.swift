//
//  StartView.swift
//  humanana
//
//  Created by Leo Huang on 2022-09-17.
//

import SwiftUI

struct StartView: View {
    @StateObject var viewModel = ViewModel()
    
    let backgroundGradient = LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom)

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            NavigationLink(
                destination: CaptureView().environmentObject(viewModel),
                label: {
                    ZStack {
                        backgroundGradient
                            .ignoresSafeArea()
                        VStack(spacing: 128) {
                            Text("humanana")
                                .font(.custom("Comfortaa", size: 60))
                            Text("tap anywhere to continue")
                                .font(.custom("Comfortaa", size: 18))
                        }
                    }
                    .foregroundColor(.black)
                })
        }
    }
}

class ViewModel: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
