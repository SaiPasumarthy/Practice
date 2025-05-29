import SwiftUI

public struct SPButton: View {
    private let title: String
    private let action: () -> Void
    private var style: ButtonStyle = .primary
    private var isEnabled: Bool = true
    
    public init(
        title: String,
        style: ButtonStyle = .primary,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.isEnabled = isEnabled
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .foregroundColor(style.foregroundColor)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isEnabled ? style.backgroundColor : .gray)
                )
        }
        .disabled(!isEnabled)
    }
    
    public enum ButtonStyle {
        case primary
        case secondary
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return .blue
            case .secondary:
                return .white
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .primary:
                return .white
            case .secondary:
                return .blue
            }
        }
    }
}

#if DEBUG
struct SPButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            SPButton(title: "Primary Button") {
                print("Primary tapped")
            }
            
            SPButton(title: "Secondary Button", style: .secondary) {
                print("Secondary tapped")
            }
            
            SPButton(title: "Disabled Button", isEnabled: false) {
                print("Disabled tapped")
            }
        }
        .padding()
    }
}
#endif
