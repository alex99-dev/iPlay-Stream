//
//  SettingsController.swift
//  iPlay Stream
//
//  Created by Buliga Alexandru on 19.03.2021.
//


import UIKit
import MessageUI



class SettingsController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    var link: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if (indexPath.row == 0)
        {
            let mailComposeViewController = configureMailComposer()
            if MFMailComposeViewController.canSendMail(){
                self.present(mailComposeViewController, animated: true, completion: nil)
            }else{
                
            }
            
        }
        
        else if (indexPath.row == 1) {performSegue(withIdentifier: "aboutSegue", sender: self)}
        else if (indexPath.row == 2) {shareApp()}
        else if (indexPath.row == 3)
        {
            clearData()
        }
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configureMailComposer() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["buliga.alexandru99@gmail.com"])
        mailComposeVC.setSubject("SUPPORT - IPlay Stream")
        mailComposeVC.setMessageBody("Scrie mesajul tau aici: ", isHTML: false)
        return mailComposeVC
    }
    
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    func shareApp()
    {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        UIGraphicsEndImageContext()
        
        let textToShare = "Descarcă și tu aplicația IPlay Stream"
        
        if let myWebsite = URL(string: "http://itunes.apple.com") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            
            
            
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    
    func clearData()
    {
        let alert = UIAlertController(title: "Clear data", message: "This will delete all your data", preferredStyle: UIAlertController.Style.alert )
        alert.view.tintColor = UIColor(red: 0.13, green: 0.57, blue: 0.98, alpha: 1.00)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            print("delete user data")
            
            VideoStruct = VideosSample
            print("refresh table")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshTable"), object: nil)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated:true, completion: nil)
    }
    
    
    
}
