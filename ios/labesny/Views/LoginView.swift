import SwiftUI

struct LoginView: View {
    @State private var isLoggedIn: Bool = false
    @State private var wantsReg: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 5) {
                Image(systemName: "globe")
                    .imageScale(.large)
                Text("XXXXXXXX")
                    .font(.custom("Helvetica", size: 20))

                
                VStack(spacing: 16) {
                    TextField("EMAIL", text: $email)
                        .font(Font.custom("Helvetica", size: 14))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    SecureField("PASSWORD", text: $password)
                        .font(Font.custom("Helvetica", size: 14))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: {
                        // Action for forgot password
                    }) {
                        Text("FORGOT PASSWORD?")
                            .font(Font.custom("Helvetica", size: 10))
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal)
                    NavigationLink(destination: HomeView())
                    {
                        Text("LOGIN")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .cornerRadius(12)
                    }
                }

            }
        }
            }
        }
#Preview {
    LoginView()
}
