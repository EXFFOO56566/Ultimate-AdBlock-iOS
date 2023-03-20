

import QuickTableViewController
import MessageUI
import UserNotifications

final class SettingsViewController: QuickTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUserInterface()
        
        tableContents = [
            
            Section(title: "Social networks", rows: [
                NavigationRow(text: "Join us on Facebook", detailText: .none, icon: .named("facebook"), action: { _ in
                    if let url = URL(string: facebookUrl) {
                        UIApplication.shared.open(url)
                    }
                }),
                NavigationRow(text: "Join us on Instagram", detailText: .none, icon: .named("instagram"), action: { _ in
                    if let url = URL(string: instagramUrl) {
                        UIApplication.shared.open(url)
                    }
                }),
                NavigationRow(text: "Join us on LinkedIn", detailText: .none, icon: .named("linkedin"), action: { _ in
                    if let url = URL(string: linkedInUrl) {
                        UIApplication.shared.open(url)
                    }
                })
            ]),
            
            Section(title: "How to activate the app?", rows: [
                NavigationRow(text: "Show tutorial", detailText: .none, icon: .named("tutorial"), action: { [self] _ in
                    let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
                    
                    if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
                        walkthroughViewController.modalPresentationStyle = .fullScreen
                        present(walkthroughViewController, animated: true, completion: nil)
                    }
                }),
            ]),
            
//            Section(title: "Do you like the app?", rows: [
//                NavigationRow(text: "Rate the app", detailText: .none, icon: .named("rate-image"), action: { [self] _ in
//                    rateApp()
//                }),
//            ]),
            
            Section(title: "Do you have any questions?", rows: [
                NavigationRow(text: "Contact us", detailText: .none, icon: .named("contact"), action: { [self] _ in
                    showMailComposer()
                }),
            ])
        ]
    }
    
    func setUpUserInterface() {
        tableView.backgroundColor = .clear
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    func showMailComposer() {
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients([contactEmail])
        composer.setSubject("Ultimate AdBlcok - Question")
        composer.setMessageBody("Hello!\n\nSubject:\n\nName:\n\nMessage:\n\n", isHTML: false)
        present(composer, animated: true)
    }
    
    func rateApp(){
        if let url = URL(string: "https://itunes.apple.com/us/app/live-space-iss-tracker/id1465174128?action=write-review"){
            UIApplication.shared.open(url, options: [:], completionHandler: {(result) in
                if result {
                    print ("Success")
                } else {
                    print ("Failed")
                }
            })
        }
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error {
            controller.dismiss(animated: true)
            return
        }
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed to send")
        case .saved:
            print("Saved")
        case .sent:
            print("Email Sent")
        }
        controller.dismiss(animated: true)
    }
}
