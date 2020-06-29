//
//  JetLayout
//
//  Copyright © 2020 Vladimir Benkevich
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit
import RxSwift
import JetLayout

class BindingsViewController: UIViewController {
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bindings sample"
        body.root(of: self)
    }
    
    var body: View {
        let viewModel = self.viewModel
        
        return ZStack {
            
            // Widget can be created from any UIView
            Widget(UIActivityIndicatorView())
                .alignment(.center())
                // Sample of custom UIView setup before adding to layout
                .setup(block: { view in
                    view.hidesWhenStopped = true
                    view.color = .red
                })
                // UIView hold reference to the dispose bag
                .bind(viewModel.$showActivity) { (view, show) in
                    if (show) {
                        view.startAnimating()
                    } else {
                        view.stopAnimating()
                    }
                }
            
            VStack(spacing: 8) {
                Image(#imageLiteral(resourceName: "Logo"))
                
                Empty(height: 8)
                
                Text("Email")
                Field(viewModel.$email)
                    .contentType(.emailAddress)
                    .placeholder("email@example.com")
                    .disabled(source: viewModel.$showActivity)

                Empty(height: 8)
                
                Text("Password")
                Field(viewModel.$password)
                    .isSecureTextEntry(true)
                    .disabled(source: viewModel.$showActivity)
                    .placeholder("your password")
                
                Empty(height: 8)
                
                HStack(spacing: 8) {
                    Text("I accept terms and conditions: ")
                        .numberOfLines(2)
                    
                    Switch(viewModel.$termsAccepted)
                }
                
                Empty(height: 24)
                
                Button(type: .system, title: "Sign In")
                    .corner(radius: 8)
                    .size(height: 32)
                    .font(.boldSystemFont(ofSize: 16))
                    .align(left: 16, right: 16)
                    .visible(bind: viewModel.$termsAccepted)
                    .enabled(source: viewModel.canLogin)
                    .tap { [unowned viewModel] in viewModel.performLogin() }
            }
            .alignment(Alignment.top(48).left(48).right(48))
            
        }.background(UIColor.white)
    }
    
    class ViewModel {
        
        @Observed
        var email: String?
        
        @Observed
        var password: String?
        
        @Observed
        var termsAccepted = false
        
        @Observed
        var showActivity = false
        
        var canLogin: Observable<Bool> {
            return Observable.combineLatest($email, $password, $showActivity) { email, password, activity in
                guard let email = email, let password = password else { return false }
                return !email.isEmpty && !password.isEmpty && !activity
            }
        }
        
        func performLogin() {
            showActivity = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
                self?.showActivity = false
            }
        }
    }
}
