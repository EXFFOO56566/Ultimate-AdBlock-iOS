

import UIKit
import Purchases
import DTGradientButton
import SafariServices

class MainViewController: UIViewController {
    
    @IBOutlet weak var ipAddressLabel: UILabel!
    @IBOutlet weak var payWallButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    var adblockIsActive = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ipAddressLabel.text = "IP address: \(UIDevice.current.getIP() ?? "192.168.0.1")"
        
        userInterfaceSetUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            
            if purchaserInfo?.entitlements["fullappaccess"]?.isActive == true {
                print("USER IS SUBSCRIBED")
                
                let save = UserDefaults(suiteName: "group.ad.block")
                save!.set(true, forKey: "user_is_subscribed")
                save!.synchronize()
                
                SFContentBlockerManager.reloadContentBlocker(withIdentifier: "com.iuliyal.skylineadblocker.ContentBlock", completionHandler: { error in
                    print(error as Any)
                })
                
            } else {
                print("USER IS NOT SUBSCRIBED")
                
                let save = UserDefaults(suiteName: "group.ad.block")
                save!.set(nil, forKey: "user_is_subscribed")
                save!.synchronize()
                
                SFContentBlockerManager.reloadContentBlocker(withIdentifier: "com.iuliyal.skylineadblocker.ContentBlock", completionHandler: { error in
                    print(error as Any)
                })
            }
        }
    }
    
    @IBAction func goToPaywall(_ sender: Any) {
        hapticFeedback()
    }
    
    @IBAction func startAdBlock(_ sender: Any) {
        hapticFeedback()
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            
            if purchaserInfo?.entitlements["fullappaccess"]?.isActive == true {
                print("USER IS SUBSCRIBED")
                (sender as AnyObject).setBackgroundImage(UIImage(named: "connected-image"), for: UIControl.State.normal)
            } else {
                print("USER IS NOT SUBSCRIBED")
                self.performSegue(withIdentifier: "user_not_subscribed", sender: self)
            }
        }
    }
    
    func userInterfaceSetUp() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear

        payWallButton.layer.cornerRadius = payWallButton.frame.height/2
        payWallButton.layer.masksToBounds = true
        
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if let e = error {
                print(e.localizedDescription)
            }
            
            if purchaserInfo?.entitlements["fullappaccess"]?.isActive == true {
                print("USER IS SUBSCRIBED")
                self.startButton.setBackgroundImage(UIImage(named: "connected-image"), for: UIControl.State.normal)
            } else {
                print("USER IS NOT SUBSCRIBED")
                self.startButton.setBackgroundImage(UIImage(named: "connect-image"), for: UIControl.State.normal)
            }
        }
    }

    func addLogoToNavigationBarItem() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: navBarImageSize).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: logoImage)
        
        let contentView = UIView()
        self.navigationItem.titleView = contentView
        self.navigationItem.titleView?.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

extension UIDevice {
    func getIP() -> String? {
        
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        
        if getifaddrs(&ifaddr) == 0 {
            
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                
                guard let interface = ptr?.pointee else {
                    return nil
                }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    guard let ifa_name = interface.ifa_name else {
                        return nil
                    }
                    let name: String = String(cString: ifa_name)
                    
                    if name == "en0" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                    
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return address
    }
    
}

