import SwiftUI
import Auth0

struct MainView: View {
    @State var user: User?
    @State var token: String? = "q_eY2hAEb0aUCkHU-qU3Ig_dup"
//     var token: String? = nil
    var body: some View {
        
       
        if let user = self.user {
            
            VStack {
                let userProfile = user;
//                if(userProfile.otherIdentities != "none"){
//                    
//                    AccountLinkingView(user: user)
//                }

                    ProfileView(user: user)
                    Button("Logout", action: self.logout)

            }
        } else {
            if let unwrappedString = token    {
                               VStack {
                                   
                                   HeroView()
                                   Text("The opaque token in cache is");
                                   TextField("The opaque token is",text: Binding(get: {
                                       token ?? ""
                                   }, set: { newValue in
                                       token = newValue
                                   }))
                                   .padding()
                                   Button( "Login with existingToken",action: {self.loginWithROPG(connection:"DBforTokenVerification", token : token ?? "")})
                                   Button( "Login with Password",action: {self.login(connection:"DBForEmailTT")})
                                   Button( "Login with SMS OTP",action: {self.login(connection:"sms")})
                               }
                               
                               
                           }
                           else {
                               
                               VStack {
                                   HeroView()
                                   Button( "Login with Email OTP",action: {self.login(connection:"email")})
                                   Button( "Login with SMS OTP",action: {self.login(connection:"sms")})
                                   Button( "Login with Password",action: {self.login(connection:"DBForEmailTT")})
                              }
                           }
        
        }
    }
}


//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        // Handle the URL here
//        if url.scheme == "com.auth0.samples.abhishek-sa" {
//            print("hreer")
//            return true
//        }
//        return false
//    }
//
//    // Other methods...
//}


extension MainView {
    func login(connection : String) {
        print("connection with: \(connection)")
        Auth0
            .webAuth()
//            .useEphemeralSession()
            .parameters(["connection": "sms", "scope" : "openid email profile", "audience": "https://abhishek-customers.us.auth0.com/userinfo"])  //connection created for user login
            .start { result in
                switch result {
                case .success(let credentials):
                    print("success with: \(credentials)")
                    print("success with: \(credentials.idToken)")
                    print("success with: \(credentials.accessToken)")
                    self.user = User(from: credentials.idToken)
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
    }
    
    
//    func loginWithROPG(connection : String, token : String) {
//        Auth0
//            .authentication()
//            .login(
//                usernameOrEmail: token,
//                password: token,
//                realmOrConnection: "DBforTokenVerification"
////                audience: "https://your-api-audience",
////                scope: "openid profile email"
//            )
//            .start { result in
//                switch result {
//                case .success(let credentials):
//                    print("success with: \(credentials)")
//                    self.user = User(from: credentials.idToken)
//                    print("success with: \(User(from: credentials.idToken))")
//                    print("success with: \(String(describing: self.user))")
//                case .failure(let error):
//                    print("Failed with: \(error)")
//                }
//            }
//    }
    func loginWithROPG(connection : String, token : String) {
        Auth0
            .authentication()
            .login(
                usernameOrEmail: token, //opaque token
                password: token, //opaque token
                realmOrConnection: "DBforTokenVerification",  //Name of DB created for token exchange
//                audience: "https://your-api-audience",
                scope: "openid profile email"
            )
            .start { result in
                switch result {
                case .success(let credentials):
                    self.user = User(from: credentials.idToken)
                    
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
    }
    func logout() {
        Auth0
            .webAuth()
            .clearSession { result in
                switch result {
                case .success:
                    self.user = nil
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
    }
}
