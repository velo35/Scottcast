//
//  MovingTextView.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/11/24.
//

import SwiftUI

class MovingText: UIView
{
    let first = UILabel()
    let second = UILabel()
    
    var startTimer: Timer?
    var animationTimer: Timer?
    
    let gap = 20.0
    
    convenience init(text: String)
    {
        self.init(frame: .zero)
        
        for label in [first, second] {
            label.text = text
            label.translatesAutoresizingMaskIntoConstraints = false
            label.sizeToFit()
        }
        self.addSubview(self.first)
        self.clipsToBounds = true
    }
    
    var text: String
    {
        get {
            self.first.text ?? ""
        }
        set {
            for label in [first, second] {
                label.text = newValue
                label.sizeToFit()
            }
            self.update()
        }
    }
    
    func update()
    {
        self.startTimer?.invalidate()
        self.animationTimer?.invalidate()
        
        if self.frame.width < first.frame.width {
            self.startTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [unowned self] _ in
                self.animationTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 30.0, repeats: true) { [unowned self] _ in
                    self.bounds.origin.x = (self.bounds.origin.x + 1).truncatingRemainder(dividingBy: self.first.frame.width + self.gap)
                }
            }
            
            self.addSubview(self.second)
            self.second.frame.origin.x = self.first.frame.size.width + self.gap
        }
        else {
            self.mask = nil
            self.second.removeFromSuperview()
        }
    }
}

struct _MovingTextView: UIViewRepresentable
{
    let text: String
    
    func makeUIView(context: Context) -> MovingText
    {
        MovingText(text: text)
    }
    
    func updateUIView(_ uiView: MovingText, context: Context)
    {
        uiView.text = text
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: MovingText, context: Context) -> CGSize?
    {
        guard let width = proposal.width, !width.isInfinite && !width.isZero else { return nil }
        let height = uiView.first.frame.height
        uiView.frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        uiView.update()
        return CGSize(width: width, height: height)
    }
    
    static func dismantleUIView(_ uiView: MovingText, coordinator: ())
    {
        uiView.startTimer?.invalidate()
        uiView.animationTimer?.invalidate()
    }
}

struct MovingTextView: View
{
    let text: String
    
    var body: some View
    {
        _MovingTextView(text: text)
            .mask {
                LinearGradient(
                    stops: [
                        .init(color: .white, location: 0.75),
                        .init(color: .clear, location: 1)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            }
    }
}

#Preview {
    MovingTextView(text: "Hello my name is Tom how are you today?")
}
