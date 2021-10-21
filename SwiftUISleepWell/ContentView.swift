//
//  ContentView.swift
//  SwiftUISleepWell
//
//  Created by Rizky Agung Kala Maghribi on 10/04/21.
//

import CoreHaptics
import SwiftUI

struct ContentView: View {
    @State private var breatheIn = false
    @State private var breathOut = false
    @State private var hold = false
    @State private var circularMotion = false
    @State private var displayHold = false
    @State private var displayBreathOut = false
    @State private var hideBreathOut = false
    @State private var showBreathIn = false
    @State private var hideBreathIn = false
    @State private var hideHold = false
    @State private var displaySeconHold = false
    @State private var hideSecondHold = false
    @State var isStart : Bool = false
    @State private var engine : CHHapticEngine?
    
    let lilac = Color("darkPurple")
    let sea = Color("blue")
    let steel = Color("grey")
    let cloud = Color("white")
    let screenBG = Color("black")
    let buttonPlay = Color("lightPurple")
    let fillGradient = LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .bottomLeading, endPoint: .topTrailing)
    
    var body: some View {
        ZStack{
            ZStack{
                screenBG
                    .edgesIgnoringSafeArea(.all)
                
                ZStack { //Circle Container
                                            
                    fillGradient // Main Circle
                        .clipShape(Circle())
                        .frame(width: 340, height: 340)
                    
                    //Gambar
                    Image("Asset 1")
                        .resizable()
                        .frame(width: 325, height: 325)
                    
                    Circle() //Hold Circle
                        .stroke(lineWidth: 5)
                        .frame(width: 370, height: 370)
                        .foregroundColor(steel)
                    
                    Circle() //Exhale Circle
                        .trim(from: 0, to: 1/4)
                        .stroke(lineWidth: 5)
                        .frame(width: 370, height: 370)
                        .foregroundColor(sea)
                        .rotationEffect(.degrees(-90))
                    
                    Circle() //Inhale Circle
                        .trim(from: 0, to: 1/4)
                        .stroke(lineWidth: 5)
                        .frame(width: 370, height: 370)
                        .foregroundColor(lilac)
                        .rotationEffect(.degrees(90))
                    
                    Capsule() //Bottom
                        .trim(from: 1/2, to: 1)
                        .frame(width: 20, height: 25)
                        .foregroundColor(cloud)
                        .offset(y: 187)
                    
                    Capsule() //Top
                        .trim(from: 1/2, to: 1)
                        .frame(width: 20, height: 25)
                        .foregroundColor(cloud)
                        .rotationEffect(.degrees(180))
                        .offset(y: -187)
                    
                    Capsule() //Right
                        .trim(from: 1/2, to: 1)
                        .frame(width: 20, height: 25)
                        .foregroundColor(cloud)
                        .rotationEffect(.degrees(-90))
                        .offset(x: 187)
                    
                    Capsule() //Left
                        .trim(from: 1/2, to: 1)
                        .frame(width: 20, height: 25)
                        .foregroundColor(cloud)
                        .rotationEffect(.degrees(90))
                        .offset(x: -187)
                    
                    ZStack{
                        Circle() // Capsule Path
                            .stroke()
                            .frame(width: 360, height: 360)
                            .opacity(0)
                        
                        Capsule() // Rotating Capsule
                            .trim(from: 1/2, to: 1)
                            .frame(width: 20, height: 25)
                            .foregroundColor(sea)
                            .offset(y: 187)
                            .rotationEffect(.degrees(circularMotion ? 360 : 0))
                    }
                    
                }.frame(width: 360, height: 360)
                .scaleEffect(breatheIn ? 0.95 : 0.8)
                .scaleEffect(hold ? 1 : 1)
                .scaleEffect(breathOut ? 0.8 : 0.95)
                
                //Start Animation
                
                ZStack {
                    
                    Text("Breath Out").font(.largeTitle).fontWeight(.semibold).multilineTextAlignment(.center)
                        .foregroundColor(cloud)
                        .scaleEffect(1)
                        .opacity(displayBreathOut ? 1 : 0)
                        .opacity(hideBreathOut ? 0 : 1)
                        .offset(y: 235)
                    
                    Text("Hold").font(.largeTitle).fontWeight(.semibold).multilineTextAlignment(.center)//Second Hold
                        .foregroundColor(cloud)
                        .scaleEffect(1)
                        .opacity(displaySeconHold ? 1 : 0)
                        .opacity(hideSecondHold ? 0 : 1)
                        .offset(y: 235)
                    
                    Text("Hold").font(.largeTitle).fontWeight(.semibold).multilineTextAlignment(.center)
                        .foregroundColor(cloud)
                        .scaleEffect(1)
                        .opacity(displayHold ? 1 : 0)
                        .opacity(hideHold ? 0 : 1)
                        .offset(y: 235)
                    
                    Text("Breath In").font(.largeTitle).fontWeight(.semibold).multilineTextAlignment(.center)
                        .foregroundColor(cloud)
                        .opacity(showBreathIn ? 1 : 0)
                        .offset(y: 235)
                    
                    Text("Sleep Well").font(.largeTitle).fontWeight(.semibold).multilineTextAlignment(.center)
                        .foregroundColor(cloud)
                        .offset(y:-365)
                    
                    Text("Start").font(.largeTitle).fontWeight(.semibold).multilineTextAlignment(.center)
                        .foregroundColor(cloud)
                        .opacity(isStart ? 0 : 1)
                        .offset(y: 235)
                }
                
            }
            Button(action: {
                self.playBreath(iteration: 0)
                let buttonTapped = UIImpactFeedbackGenerator(style: .medium)
                    buttonTapped.impactOccurred()
            }, label: {
                Image(systemName: isStart ? "stop.circle.fill" : "play.circle.fill")
                    .foregroundColor(buttonPlay)
                    .font(Font.system(size: 65))
            })
            .offset(y: 335)
        }
    }
    
//    //Button Haptics
//    func buttonHaptics() {
//        let generator = UINotificationFeedbackGenerator()
//        generator.notificationOccurred(.success)
//    }
    
    //Prapare Haptics (Device Check)
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {return}
        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func breathHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {return}
        var events = [CHHapticEvent]()
        
        //Haptics Breathing
        for i in stride(from: 0, to: 4, by: 0.1){
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity,sharpness], relativeTime: i)
            events.append(event)
        }
        for i in stride(from: 0, to: 4, by: 0.1){
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity,sharpness], relativeTime: 1 + i)
            events.append(event)
        }
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    
    // START BREATH
    func playBreath(iteration: Int){
        if iteration > 2 {
            return
        }
        self.isStart.toggle()
        if isStart {
            self.showBreathIn.toggle()
            //return to start state
            DispatchQueue.main.asyncAfter(deadline: .now()+16, execute: {
                self.isStart = false
                self.breathOut = false
                self.breatheIn = false
                self.circularMotion = false
                self.displayBreathOut = false
                self.hideBreathOut = false
                self.displaySeconHold = false
                self.hideSecondHold = false
                self.displayHold = false
                self.hideHold = false
                self.hideBreathIn = false
                playBreath(iteration: iteration+1)
            })
            prepareHaptics()
            //Capsule Rotate
            withAnimation(Animation.linear(duration: 16)) {
                self.circularMotion = true
            }
            //Main Circle Animation
            withAnimation(Animation.linear(duration: 4)){
                self.breatheIn.toggle()
            }
            withAnimation(Animation.linear(duration: 4).delay(4)){
                self.hold.toggle()
            }
            withAnimation(Animation.linear(duration: 4).delay(8)){
                self.breathOut.toggle()
            }
            withAnimation(Animation.linear(duration: 4).delay(12)){
                self.hold.toggle()
            }
            //Breath Out
            withAnimation(Animation.easeInOut(duration: 0.4).delay(8)){
                self.displayBreathOut.toggle()
            }
            withAnimation(Animation.easeInOut(duration: 0.4).delay(12)){
                self.hideBreathOut.toggle()
            }
            //Second Hold
            withAnimation(Animation.easeInOut(duration: 0.4).delay(12)){
                self.displaySeconHold.toggle()
            }
            withAnimation(Animation.easeInOut(duration: 0.4).delay(16)){
                self.hideSecondHold.toggle()
            }
            //First Hold
            withAnimation(Animation.easeInOut(duration: 0.4).delay(4)){
                self.displayHold.toggle()
            }
            withAnimation(Animation.easeInOut(duration: 0.4).delay(8)){
                self.hideHold.toggle()
            }
            //Breath In
            withAnimation(Animation.easeInOut(duration: 0.4).delay(4)){
                self.showBreathIn.toggle()
                self.hideBreathIn.toggle()
                breathHaptics()
            }
        }else {
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
    }
}
