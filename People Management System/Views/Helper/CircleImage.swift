//
//  CircleImage.swift
//  Megan
//
//  Created by Megan Lin on 2/16/24.
//

import SwiftUI

struct CircleImage: View {
    var image: Image

    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill) // Adjust content mode as needed
            .frame(width: 300, height: 300) // Set the desired size
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

#Preview {
    CircleImage(image: Image("pic"))
}
