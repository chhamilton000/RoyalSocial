//
//  HeartAnimation.swift
//  RoyalSocial
//
//  Created by Caley Hamilton on 10/18/23.
//

import SwiftUI

struct HeartAnimation: View{
    
    // Animation Properites....
    @Binding var isTapped: Bool
    
    @State var startAnimation = false
    @State var bgAnimation = false
    // Resetting Bg....
    @State var resetBG = false
    @State var fireworkAnimation = false
    
    @State var animationEnded = false
    
    // To Avoid Taps during Animation...
    @State var tapComplete = false
    
    // Setting How Many taps...
    var taps: Int = 1
    
    var body: some View{
        
        // Heart Like Animation....
        Image(systemName: resetBG ? "suit.heart.fill" : "suit.heart")
            .font(.system(size: 45))
            .foregroundColor(resetBG ? .red : .gray)
        // Scaling...
            .scaleEffect(startAnimation && !resetBG ? 0 : 1)
            .opacity(startAnimation && !animationEnded ? 1 : 0)
        // BG...
            .background(
            
                ZStack{
                    
                    CustomShape(radius: resetBG ? 29 : 0)
                        .fill(Color.purple)
                        .clipShape(Circle())
                        // Fixed Size...
                        .frame(width: 50, height: 50)
                        .scaleEffect(bgAnimation ? 2.2 : 0)
                    
                    ZStack{
                        
                        // random Colors..
                        let colors: [Color] = [.red,.purple,.green,.yellow,.pink]
                        
                        ForEach(1...6,id: \.self){index in
                            
                            Circle()
                                .fill(colors.randomElement()!)
                                .frame(width: 12, height: 12)
                                .offset(x: fireworkAnimation ? 80 : 40)
                                .rotationEffect(.init(degrees: Double(index) * 60))
                        }
                        
                        ForEach(1...6,id: \.self){index in
                            
                            Circle()
                                .fill(colors.randomElement()!)
                                .frame(width: 8, height: 8)
                                .offset(x: fireworkAnimation ? 64 : 24)
                                .rotationEffect(.init(degrees: Double(index) * 60))
                                .rotationEffect(.init(degrees: -45))
                        }
                    }
                    .opacity(resetBG ? 1 : 0)
                    .opacity(animationEnded ? 0 : 1)
                }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .contentShape(Rectangle())
            .onChange(of: isTapped) { newValue in
                if newValue{
                    startHeartAnimation()
                    isTapped = false
                }
            }
//            .onChange(of: isTapped) { newValue in
//                if isTapped && !startAnimation{
//                    // setting everything to true...
//                    updateFields(value: true)
//                }
//                
//                if !isTapped{
//                    updateFields(value: false)
//                }
//            }
        
    }
    
    func startHeartAnimation(){
        // Reset the control variables for a new animation
        resetAnimationState()
        
        // Start the animation
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)){
            startAnimation = true
        }
        
        // Execute the sequence of animations
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)){
                bgAnimation = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)){
                    resetBG = true
                }
                
                withAnimation(.spring()){
                    fireworkAnimation = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.easeOut(duration: 0.4)){
                        animationEnded = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        tapComplete = true  // Now set to true only once, at the end of the animation
                    }
                }
            }
        }
    }
    
    func resetAnimationState() {
        startAnimation = false
        bgAnimation = false
        resetBG = false
        fireworkAnimation = false
        animationEnded = false
        tapComplete = false
    }
    
    func updateFields(value: Bool){
        
        startAnimation = value
        bgAnimation = value
        resetBG = value
        fireworkAnimation = value
        animationEnded = value
        tapComplete = value
        isTapped = value
    }
}

// Custom Shape
// For Resetting from center...
struct CustomShape: Shape{
    
    // value...
    var radius: CGFloat
    
    // animating Path...
    var animatableData: CGFloat{
        get{return radius}
        set{radius = newValue}
    }
    
    // Animatable path wont work on previews....
    
    func path(in rect: CGRect) -> Path {
        
        return Path{path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            
            // adding Center Circle....
            let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
            path.move(to: center)
            path.addArc(center: center, radius: radius, startAngle: .zero, endAngle: .init(degrees: 360), clockwise: false)
        }
    }
}
