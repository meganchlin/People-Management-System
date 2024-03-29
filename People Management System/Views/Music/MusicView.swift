//
//  MusicView.swift
//  Megan
//
//  Created by Megan Lin on 3/2/24.
//

import SwiftUI

struct MusicView: View {
    @State private var animation = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            SheetMusicLines()
            HStack(spacing: 20) {
                Note1()
                    //.offset(createCurvedPath(offset: 0))
                    //.transition(.slide)
                    .offset(x: animation ? 30 : 80, y: animation ? 20: -10)
                    .animation(.linear(duration: 2).repeatForever(autoreverses: false),
                               value: animation)
                Note3()
                    .offset(x: animation ? 0 : 50, y: animation ? -30: 0)
                    .animation(.linear(duration: 2).repeatForever(autoreverses: false),
                               value: animation)
                Note2()
                    .offset(x: animation ? -30 : 20, y: animation ? -20: 50)
                    .animation(.linear(duration: 2).repeatForever(autoreverses: false),
                               value: animation)
                Note3()
                    .offset(x: animation ? -60 : -10, y: animation ? 50: 0)
                    .animation(.linear(duration: 2).repeatForever(autoreverses: false),
                               value: animation)
            }
            .scaleEffect(0.7)
        }
        .onAppear{
            animation.toggle()
        }
    }
}

struct SheetMusicLines: View {
    var body: some View {
        VStack(spacing: 20) {
            ForEach(0..<5) { _ in
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 300, height: 4)
            }
        }
    }
}

#Preview {
    MusicView()
}
