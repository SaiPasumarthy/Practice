//
//  ContentView.swift
//  StateManagement
//
//  Created by Sai Pasumarthy on 09/04/23.
//

import SwiftUI

enum AnimationState {
    case animation
    case noAnimation
}
enum SegmentAnimationState: Hashable {
    case Segment1Animation
    case Segment2Animation
}

struct ContentView: View {
    @State var segmentIndex: Int = 0
    let contentViewModel: ContentViewModel
    var body: some View {
        VStack {
            TabView(onAction: segmentCallback)
                .padding()
            getSubSegmentView(with: segmentIndex)
            Spacer()
        }
    }
    
    private func segmentCallback(with index: Int) {
        segmentIndex = index
    }
    
    @ViewBuilder
    func getSubSegmentView(with index: Int) -> some View {
        if segmentIndex == 0 {
            Segment1View(canAnimate: contentViewModel.canAnimate(.Segment1Animation))
        } else {
            Segment2View(canAnimate: contentViewModel.canAnimate(.Segment2Animation))
        }
    }
    
    // MARK: - Boolean approach
    func getSegment1AnimationStatus() -> Bool {
        let status = contentViewModel.segment1AnimationStatus
        if !status {
            contentViewModel.updateSegment1AnimationStatus(true)
        }
        return !status
    }
    
    func getSegment2AnimationStatus() -> Bool {
        let status = contentViewModel.segment2AnimationStatus
        if !status {
            contentViewModel.updateSegment2AnimationStatus(true)
        }
        return !status
    }
}

class ContentViewModel {
    // Boolean approach
    private(set) var segment1AnimationStatus: Bool = false
    private(set) var segment2AnimationStatus: Bool = false
    
    func updateSegment1AnimationStatus(_ status: Bool) {
        segment1AnimationStatus = status
    }
    func updateSegment2AnimationStatus(_ status: Bool) {
        segment2AnimationStatus = status
    }
    
    // Enum approach
    private var segmentAnimationState: [SegmentAnimationState: AnimationState] = [:]
    
    func canAnimate(_ view: SegmentAnimationState) -> Bool {
        if segmentAnimationState.keys.contains(view) {
            if let status = segmentAnimationState[view] {
                return status == .animation
            }
        }
        segmentAnimationState[view] = .noAnimation
        return true
    }
}

struct TabView: View {
    let onAction: (Int) -> Void
    var body: some View {
        HStack {
            Button("Segment 1") {
                onAction(0)
            }
            Button("Segment 2") {
                onAction(1)
            }
        }
    }
}

struct Segment1View: View {
    var canAnimate: Bool
    @State var showFullOpacity: Bool = false
    var body: some View {
        Text("Segment 1 View")
            .font(.body)
            .opacity(showFullOpacity ? 1 : 0)
            .onAppear {
                if canAnimate {
                    withAnimation(.linear(duration: 2.0).delay(0.1)) {
                        showFullOpacity = true
                    }
                } else {
                    showFullOpacity = true
                }
            }
    }
}

struct Segment2View: View {
    var canAnimate: Bool
    @State var showFullOpacity: Bool = false
    var body: some View {
        Text("Segment 2 View")
            .font(.body)
            .opacity(showFullOpacity ? 1 : 0)
            .onAppear {
                if canAnimate {
                    withAnimation(.linear(duration: 2.0).delay(0.1)) {
                        showFullOpacity = true
                    }
                } else {
                    showFullOpacity = true
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var contentViewModel: ContentViewModel = ContentViewModel()
    static var previews: some View {
        ContentView(contentViewModel: contentViewModel)
    }
}
