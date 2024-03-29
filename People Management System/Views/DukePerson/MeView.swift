//
//  MeView.swift
//  Megan
//
//  Created by Megan Lin on 3/2/24.
//

import SwiftUI

struct MeView: View {
    var dukePerson: DukePerson
    
    @State private var showContent: Bool = false
    
    var body: some View {
        if !showContent {
            initial(showContent: $showContent)
        } else {
            content(showContent: $showContent, dukePerson: dukePerson)
                .navigationTitle(dukePerson.netID)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct initial: View {
    @Binding var showContent: Bool
    
    @State var text: AttributedString = ""
    let finalText: String = "Welcome to my page!"
    
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1
    @State private var opacity: Double = 1
    @State private var isAnimating: Bool = false
    //@State private var cursorVisible = false
    
    func typeWriter(at position: Int = 0) {
        if position == 0 {
            text = AttributedString("")
        }
        if position < finalText.count, let index = finalText.index(finalText.startIndex, offsetBy: position, limitedBy: finalText.endIndex) {
            let char = finalText[index]
            //print(char)  // This will print 'H'
            
            var addChar = AttributedString(String(char))
            addChar.font = .custom("Courier", size: 28)
            addChar.foregroundColor = .primary
        
            // ref: https://betterprogramming.pub/typewriter-effect-in-swiftui-ba81db10b570
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                text.append(addChar)
                typeWriter(at: position + 1)
            }
        }
    }
    
    struct CursorView: View {
        @State private var isVisible = true

        var body: some View {
            // Custom cursor view with flashing effect
            Text("|")
                .font(.custom("Courier", size: 28))
                .foregroundColor(.primary)
                .opacity(isVisible ? 1 : 0)
                .onAppear {
                    // Start flashing animation
                    withAnimation(.easeInOut(duration: 0.5).repeatForever()) {
                        isVisible.toggle()
                    }
                }
        }
    }

    var body: some View {
        HStack {
            Text(text)
            CursorView()
        }
        
        Image("sci-fi")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 120, height: 120)
            .padding(.top, 80)
        
            .rotation3DEffect(
                .degrees(rotation),
                axis: (x: 0, y: 1, z: 0) // Rotate around the Y-axis
            )
            .scaleEffect(scale)
            .opacity(opacity)
            .animation(
                Animation.easeInOut(duration: 5), value: isAnimating
            )
            .onTapGesture {
                isAnimating.toggle()
                print(isAnimating)
                
                withAnimation {
                    rotation = isAnimating ? 720 : 0
                    scale = isAnimating ? 0.3 : 1
                    opacity = isAnimating ? 0 : 1
                }
                    
                    
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showContent.toggle()
                }
                    
            }
            .onAppear{
                typeWriter()
            }
    }
}

struct content: View {
    @Binding var showContent: Bool
    
    var dukePerson: DukePerson
    
    var name: AttributedString {
        var result = AttributedString("Megan Lin")
        result.font = .custom("Bodoni 72", size: 30)
        result.foregroundColor = .black
        return result
    }
    
    var body: some View {
        MusicView()
            .padding(.top, 20)
        ScrollView {
            HStack {
                CircleImage(image: imageFromString(dukePerson.picture))
                    .scaleEffect(0.4)
                    .frame(width: 180, height: 150)
                    .padding(.top, 30)
                    //.padding(.bottom, 0)
                Spacer()
                Button(action: {
                    showContent.toggle()
                }, label: {
                    Text(AttributedString("Intro"))
                        .underline(true, color: .blue)
                        .font(.custom("Bodoni 72", size: 24))
                        .foregroundColor(.brown)
                        .bold()
                    Image(systemName: "arrow.up.left.square")
                        .imageScale(.large)
                })
                .padding(.top, 20)
                Spacer()
            }
            VStack(spacing: 20) {
                HStack {
                    Text(name)
                }

                HStack {
                    Text(dukePerson.role.rawValue)
                    Spacer()
                    Text(dukePerson.program.rawValue)
                    Text(dukePerson.plan.rawValue)
                }
                .font(.custom("Georgia", size: 18))
                .foregroundStyle(.secondary)

                Divider()

                Text("About")
                    .font(.custom("Bodoni 72", size: 24))
                Text(dukePerson.description)
                    .font(.custom("Georgia", size: 18))
            }
            .padding()
            
        }
    }
}


#Preview {
    let modelData = ModelData()
    return MeView(dukePerson: modelData.DukePeople[123456]!)
}
