

import UIKit
import WebKit
import Purchases

class PrivacyViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate {

    @IBOutlet weak var privacyWebView: WKWebView!
    @IBOutlet weak var acceptPrivacyButton: UIButton!
    
    var isUrlLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light

        privacyWebView.navigationDelegate = self
        privacyWebView.scrollView.delegate = self
        
        acceptPrivacyButton.isEnabled = false
        acceptPrivacyButton.backgroundColor = UIColor(hex: "A4A4A4")
        
        setUpWebView()
        setupUserInterface()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        if (scrollView.contentOffset.y + 1) >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
                acceptPrivacyButton.isEnabled = true
                acceptPrivacyButton.backgroundColor = UIColor(hex: "00B9FB")
            } else if scrollView.contentOffset.y < scrollView.contentSize.height {
                acceptPrivacyButton.isEnabled = false
                acceptPrivacyButton.backgroundColor = UIColor(hex: "A4A4A4")
            }
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        isUrlLoaded = true
    }
    
    @IBAction func goToPrivacy(_ sender: Any) {
        hapticFeedback()
        
        let save = UserDefaults.standard
        save.set(true, forKey: "privacy_accepted")
        save.synchronize()
        
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            
            if purchaserInfo?.entitlements["fullappaccess"]?.isActive == true {
                self.performSegue(withIdentifier: "user_subscribed", sender: self)
            } else {
                self.performSegue(withIdentifier: "go_subscribe", sender: self)
            }
        }
    }
    
    func setUpWebView() {
        let url = URL(string: privacyPolicyUrl)
        let request = URLRequest(url: url!)
        self.privacyWebView.load(request)
    }
    
    func setupUserInterface() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()

        acceptPrivacyButton.layer.cornerRadius = acceptPrivacyButton.frame.height/2
        acceptPrivacyButton.layer.masksToBounds = true
    }
    
    func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

}
