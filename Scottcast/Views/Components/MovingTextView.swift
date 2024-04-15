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
    
    var timer: Timer?
    
    init(text: String)
    {
        super.init(frame: .zero)
        for label in [first, second] {
            label.text = text
            label.translatesAutoresizingMaskIntoConstraints = false
            label.sizeToFit()
            self.addSubview(label)
        }
        second.frame.origin.x = first.frame.size.width
        
        self.start()
    }
    
    func start()
    {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 30.0, repeats: true) { [unowned self] timer in
//            print("start \(first.frame.width), \(self.frame.width)")
            self.bounds.origin.x = (self.bounds.origin.x + 3).truncatingRemainder(dividingBy: first.frame.width)
//            if first.frame.width > self.frame.width {
//                second.isHidden = false
//            }
//            else {
//                self.bounds.origin.x = 0
//                second.isHidden = true
//            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct MovingTextView: UIViewRepresentable
{
    let text: String
    
    func makeUIView(context: Context) -> MovingText
    {
        MovingText(text: text)
    }
    
    func updateUIView(_ uiView: MovingText, context: Context)
    {
        
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: MovingText, context: Context) -> CGSize?
    {
        guard let width = proposal.width, !width.isInfinite && !width.isZero else { return nil }
        print("whooo \(proposal)")
        var frame = uiView.frame
        frame.size.width = width
        uiView.frame = frame
        return CGSize(width: width, height: uiView.first.frame.height)
    }
}

#Preview {
    MovingTextView(text: "Hello my name is Tom how are you today?")
}
