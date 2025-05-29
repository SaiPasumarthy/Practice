import SwiftUI

public struct SPTextField: View {
    private let placeholder: String
    @Binding private var text: String
    private var isSecure: Bool
    private var keyboardType: UIKeyboardType
    
    public init(
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default
    ) {
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.keyboardType = keyboardType
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textFieldStyle()
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle()
                    .keyboardType(keyboardType)
            }
        }
    }
}

private extension View {
    func textFieldStyle() -> some View {
        self
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
            )
            .font(.system(size: 16))
    }
}

#if DEBUG
struct SPTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            SPTextField(
                placeholder: "Regular text field",
                text: .constant("")
            )
            
            SPTextField(
                placeholder: "Secure text field",
                text: .constant(""),
                isSecure: true
            )
            
            SPTextField(
                placeholder: "Email",
                text: .constant(""),
                keyboardType: .emailAddress
            )
        }
        .padding()
    }
}
#endif
