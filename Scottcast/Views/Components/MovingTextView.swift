//
//  MovingTextView.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/11/24.
//

import SwiftUI

private struct MovingTextShouldMovePreference: PreferenceKey
{
    static let defaultValue = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {}
}

private struct MovingTextWidthPreference: PreferenceKey
{
    static let defaultValue = CGFloat.zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

struct MovingTextView: View
{
    let text: String
    
    @State private var shouldMove = false
    @State private var textWidth = CGFloat.zero
    @State private var offset = CGFloat.zero
    
    let gap = CGFloat(20)
    
    var body: some View
    {
        Text("A")
            .frame(maxWidth: .infinity)
            .hidden()
            .background(alignment: .leading) {
                GeometryReader { proxy in
                    Text(text)
                        .fixedSize()
                        .background {
                            GeometryReader { textProxy in
                                Color.clear
                                    .preference(key: MovingTextWidthPreference.self, value: textProxy.size.width)
                                    .onPreferenceChange(MovingTextWidthPreference.self) { value in
                                        textWidth = textProxy.size.width
                                    }
                                    .preference(key: MovingTextShouldMovePreference.self, value: proxy.size.width < textProxy.size.width)
                                    .onPreferenceChange(MovingTextShouldMovePreference.self) { value in
                                        shouldMove = value
                                        offset = CGFloat.zero
                                    }
                                    .onChange(of: shouldMove) {
                                        Task {
                                            try? await Task.sleep(nanoseconds: 3_000_000_000)
                                            if shouldMove {
                                                offset = -(textWidth + gap)
                                            }
                                        }
                                    }
                            }
                        }
                        .background {
                            if shouldMove {
                                Text(text)
                                    .offset(x: textWidth + gap)                                
                            }
                        }
                        .offset(x: offset)
                        .animation(.linear(duration: 8).repeatCount(3, autoreverses: false), value: offset)
                }
            }
            .clipped()
            .mask {
                if shouldMove {
                    LinearGradient(
                        stops: [
                            .init(color: .white, location: 0.75),
                            .init(color: .clear, location: 1)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                }
                else {
                    Color.black
                }
            }
    }
}

#Preview {
    MovingTextView(text: "Hello my name is Tom how are you today?")
}
