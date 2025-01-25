//
//  ContentView.swift
//  clicker
//
//  Created by Reese Jednorozec on 1/22/25.
//

import SwiftUI

struct ContentView: View {
    @State private var clicks: Int = 0
    
    var body: some View {
        VStack {
            Text("Clicks: \(clicks)")
        Spacer()
            Button("Click Me") {
                clicks += 1
            }
        Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
