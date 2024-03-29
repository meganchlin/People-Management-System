//
//  Note2.swift
//  Megan
//
//  Created by Megan Lin on 3/2/24.
//

import SwiftUI

struct Note2: View {
    var body: some View {
        /*
        VStack {
            ZStack {
                // Ellipse representing the head of the music note
                Ellipse()
                    .frame(width: 40, height: 25)

                // Rectangle representing the stem of the music note
                Rectangle()
                    .frame(width: 5, height: 80)
                    .offset(x: 18, y: -40)

                // Curly line
                Path { path in
                    path.move(to: CGPoint(x: 38, y: -68))
                        path.addQuadCurve(
                            to: CGPoint(x: 60, y: -5),
                            control: CGPoint(x: 70, y: -30)
                        )
                }
                    .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                    .frame(width: 40, height: 25) // Adjust the frame size as needed
                    .foregroundColor(.black)
            }
        }
         */
        Canvas { context, size in
            let ellipseSize = CGSize(width: 40, height: 25)
            let rectangleSize = CGSize(width: 5, height: 80)

            // Draw Ellipse
            context.fill(Ellipse().path(in: CGRect(origin: CGPoint(x: 25, y: 80), size: ellipseSize)), with: .color(.black))

            // Draw Rectangle
            context.fill(Rectangle().path(in: CGRect(origin: CGPoint(x: 60, y: 10), size: rectangleSize)), with: .color(.black))
            
            // Draw Curly line
            let curlyLinePath = Path { path in
                path.move(to: CGPoint(x: 62.5, y: 10))
                path.addQuadCurve(to: CGPoint(x: 85, y: 65), control: CGPoint(x: 95, y: 38))
            }
            
            context.stroke(curlyLinePath, with: .color(.black), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
        }
        .frame(width: 120, height: 120)
    }
}

#Preview {
    Note2()
}
