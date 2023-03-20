

import UIKit
import DTGradientButton
import Purchases

class SubscriptionViewController: UIViewController {
    
    @IBOutlet weak var goPremiumButton: UIButton!
    @IBOutlet weak var subscriptionLabel: UILabel!
    @IBOutlet weak var restorePurchasesButton: UIButton!
    
    var packagesAvailableForPurchase = [Purchases.Package]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locale = Locale.current
        let currencySymbol = locale.currencySymbol!
        
        Purchases.shared.offerings { (offerings, error) in
            if let offerings = offerings {
                let offer = offerings.current
                let packages = offer?.availablePackages
                
                guard packages != nil else {
                    return
                }
                
                for i in 0...packages!.count - 1 {
                    let package = packages![i]
                    
                    self.packagesAvailableForPurchase.append(package)
                    
                    let product = package.product
                    
                    let title = product.localizedTitle
                    let price = product.price
                    
                    print("Subscription data: \(title) and \(price)")
                    
                    var duration = ""
                    let subscriptionPeriod = product.subscriptionPeriod
                    
                    switch subscriptionPeriod!.unit {
                    
                    case SKProduct.PeriodUnit.month:
                        duration = "\(subscriptionPeriod!.numberOfUnits)"
                        
                    default:
                        duration = ""
                    }
                    
                    self.subscriptionLabel.text = "Start your free trial now and only \(price)\(currencySymbol) a week after the trial"
                    self.goPremiumButton.addTarget(self, action: #selector(self.goPremiumButtonTapped), for: .touchUpInside)
                    self.goPremiumButton.tag = i
                }
            }
        }
        
        setupUserInterface()
    }
    
    @IBAction func openPrivacy(_ sender: Any) {
        hapticFeedback()
        if let url = URL(string: privacyPolicyUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func openTermsOfUse(_ sender: Any) {
        hapticFeedback()
        if let url = URL(string: termsOfUseUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //Делает прозрачный верхний navigation controller
    func setupUserInterface() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        goPremiumButton.layer.cornerRadius = goPremiumButton.frame.height/2
        goPremiumButton.layer.masksToBounds = true
    }
    
    @objc func goPremiumButtonTapped(sender:UIButton) {
        
        let package = self.packagesAvailableForPurchase[sender.tag]
        
        Purchases.shared.purchasePackage(package) { (transaction, purchaserInfo, error, userCancelled) in
            if purchaserInfo?.entitlements["fullappaccess"]?.isActive == true {
                self.dismiss(animated: true, completion: nil)
            }
        }
        hapticFeedback()
    }
    
    func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
