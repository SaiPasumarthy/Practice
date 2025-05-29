import SwiftUI

public struct SPLoadingSpinner: View {
    private let color: Color
    private let lineWidth: CGFloat
    private let size: CGFloat
    @State private var isAnimating = false
    
    public init(
        color: Color = .blue,
        lineWidth: CGFloat = 3,
        size: CGFloat = 40
    ) {
        self.color = color
        self.lineWidth = lineWidth
        self.size = size
    }
    
    public var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .frame(width: size, height: size)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .animation(
                Animation.linear(duration: 1)
                    .repeatForever(autoreverses: false),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

#if DEBUG
struct SPLoadingSpinner_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            SPLoadingSpinner()
            
            SPLoadingSpinner(color: .red, lineWidth: 4, size: 60)
            
            SPLoadingSpinner(color: .green, lineWidth: 2, size: 30)
        }
    }
}
#endif
