//
//  MoreViewController.swift
//  MackNews
//
//  Created by Joaquim Pessôa Filho on 7/24/15.
//  Copyright (c) 2015 Mackenzie. All rights reserved.
//

import Foundation
import UIKit
import Social
import MessageUI
//import AlamofireImage
import Alamofire
import HTMLReader

// TODO: Colocar todo o texto no Localizable.string

class AboutTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tiaLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var userPhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        userLabel.text = TIAServer.sharedInstance.user?.name ?? TIAServer.sharedInstance.user?.tia
        
        let tia = TIAServer.sharedInstance.user?.tia ?? "tia não encontrado"
        tiaLabel.text = "TIA: \(tia)"
        
//        userPhoto?.image = UIImage(named: "icon_user")
//        userPhoto.layer.cornerRadius = userPhoto.bounds.width/2
//        userPhoto.layer.masksToBounds = true
//        
//        Alamofire.request(.GET, "http://moodle.mackenzie.br/moodle/mack_addons/fotos.php?username=\(tia)").responseString { [weak userPhoto] (response) in
//            if let result = response.result.value {
//                let doc = HTMLDocument(string: result)
//                if let imageTag = doc.firstNode(matchingSelector: "img") {
//                    if let imageURL = imageTag.attributes["src"] {
//                        print(#function, "downloading image")
//                        Alamofire.request(.GET, imageURL).responseImage { (response) in
//                            if let image = response.result.value {
//                                userPhoto?.image = image
//                            }
//                        }
//                    }
//                }
//            }
//        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let userSection = 0
        
        ///////
        let socialSection   = 2
        let fbMack      = 0
        let fbTVMack    = 1
        let fbRadio     = 2
        let twitter     = 3
        let email       = 4
        let appStore    = 5
        ///////
        
        ///////
        let equipeSection   = 3
        ///////
        
        ///////
        let apoioSection        = 4
        let paginaFCI           = 0
        let paginaMackMobile    = 1
        let paginaDTI           = 2
        ///////
        
        if (indexPath as NSIndexPath).section == equipeSection || (indexPath as NSIndexPath).section == userSection {
            tableView.deselectRow(at: indexPath, animated: false)
            return
            
        } else if (indexPath as NSIndexPath).section == socialSection {
            switch((indexPath as NSIndexPath).row){
            case fbTVMack:
                // Curtir pagina da TV Mackenzie
                var url = URL(string: "fb://profile/200809299999744")
                if url == nil || !UIApplication.shared.canOpenURL(url!) {
                    let safariURL = URL(string: "https://www.facebook.com/TvMackenzie")
                    if safariURL == nil {
                        print("Não conseguiu abrir facebook")
                        return
                    }
                    url = safariURL
                }
                UIApplication.shared.openURL(url!)
            case fbRadio:
                // Curtir pagina da Radio Mackenzie
                var url = URL(string: "fb://profile/795338763868734")
                if url == nil || !UIApplication.shared.canOpenURL(url!) {
                    let safariURL = URL(string: "https://www.facebook.com/radiomackenzie")
                    if safariURL == nil {
                        print("Não conseguiu abrir facebook")
                        return
                    }
                    url = safariURL
                }
                UIApplication.shared.openURL(url!)
            case fbMack:
                // Curtir pagina da Mackenzie
                var url = URL(string: "fb://profile/132887713419861")
                if url == nil || !UIApplication.shared.canOpenURL(url!) {
                    let safariURL = URL(string: "https://www.facebook.com/mackenzie1870")
                    if safariURL == nil {
                        print("Não conseguiu abrir facebook")
                        return
                    }
                    url = safariURL
                }
                UIApplication.shared.openURL(url!)
            case twitter:
                // Twittar sobre o aplicativo
                let compose = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                compose?.setInitialText("#mackenzie1870 #mackmobile #macktia o terminal informativo acadêmico da Universidade Presbiteriana Mackenzie, baixa já na AppStore!")
                self.present(compose!, animated: true, completion: nil)
            case email:
                // Envio de e-mail
                let compose = MFMailComposeViewController()
                compose.mailComposeDelegate = self
                compose.setToRecipients(["aplicativos@mackenzie.br"])
                self.present(compose, animated: true, completion: nil)
            case appStore:
                // Avaliar na AppStores
                let url = URL(string: "itms-apps://itunes.apple.com/app/id1116186875")
                if url != nil {
                    UIApplication.shared.openURL(url!)
                } else {
                    print("Erro ao tentar abrir AppStore")
                }
            default:
                return
            }
        } else if (indexPath as NSIndexPath).section == apoioSection {
            switch((indexPath as NSIndexPath).row) {
            case paginaFCI:
                // Curtir pagina da Mackenzie
                let url = URL(string: "http://www.mackenzie.br/fci.html")
                if url == nil || !UIApplication.shared.canOpenURL(url!) {
                    print("Não conseguiu abrir pagina da fci")
                    return
                }
                UIApplication.shared.openURL(url!)
            case paginaDTI:
                // Curtir pagina da DTI
                let url = URL(string: "http://www.mackenzie.br/dti.html")
                if url == nil || !UIApplication.shared.canOpenURL(url!) {
                    print("Não conseguiu abrir pagina da dti")
                    return
                }
                UIApplication.shared.openURL(url!)
            case paginaMackMobile:
                // Pagina do MackMobile
                let url = URL(string: "http://www.mackmobile.com.br")
                if url == nil || !UIApplication.shared.canOpenURL(url!) {
                    print("Não conseguiu abrir pagina do MackMobile")
                    return
                }
                UIApplication.shared.openURL(url!)
            default:
                return
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        switch(result.rawValue){
        case MFMailComposeResult.sent.rawValue:
            let alert = UIAlertController(title: NSLocalizedString("e-mail_successMessageSentTitle", comment: "Envio com sucesso"), message: NSLocalizedString("e-mail_successMessageSentMessage", comment: "Envio com sucesso"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        case MFMailComposeResult.failed.rawValue:
            let alert = UIAlertController(title: NSLocalizedString("e-mail_errorMessageSentTitle", comment: "Envio com sucesso"), message: NSLocalizedString("e-mail_errorMessageSentMessage", comment: "Envio com sucesso"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        default:
            return
        }
    }
    
    @IBAction func logoutButton(_ sender: AnyObject) {
        // TODO: Colocar mensagem no Localizable.strings
        let alertController = UIAlertController(title: "Sair da sua conta", message: "Caso você saida, será necessário informar seu tia e senha para acessar sua conta novamente", preferredStyle: UIAlertControllerStyle.actionSheet)
        let actionSair = UIAlertAction(title: "Sair", style: .destructive) { (alertAction) -> Void in
            TIAServer.sharedInstance.logoff()
            self.performSegue(withIdentifier: "logoutSegue", sender: self)
        }
        let actionCancelar = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
        }
        
        alertController.addAction(actionSair)
        alertController.addAction(actionCancelar)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
