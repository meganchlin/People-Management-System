//
//  Note3.swift
//  Megan
//
//  Created by Megan Lin on 3/2/24.
//

import SwiftUI

struct Note3: View {
    var body: some View {
        /*
        VStack {
            Ellipse()
                .frame(width: 40, height: 25)
                .overlay(
                    Rectangle()
                        .frame(width: 5, height: 80)
                        .offset(x: -18, y: 40)
                )
        }
         */
        Canvas { context, size in
            let ellipseSize = CGSize(width: 40, height: 25)
            let rectangleSize = CGSize(width: 5, height: 80)

            // Draw Ellipse
            context.fill(Ellipse().path(in: CGRect(origin: CGPoint(x: 45, y: 10), size: ellipseSize)), with: .color(.black))

            // Draw Rectangle
            context.fill(Rectangle().path(in: CGRect(origin: CGPoint(x: 45, y: 20), size: rectangleSize)), with: .color(.black))
        }
        .frame(width: 120, height: 120)
    }
}

#Preview {
    Note3()
}
