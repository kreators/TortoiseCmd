
import Foundation
import PerfectLib
import MySQL
import PerfectSMTP

struct NotificationEmail: EmailSendable {
    let mysql = MySQL()
    var requests = [[String:String]]()
    let dailyDepositNotificationEmail = DailyDepositNotificationEmail()
    let manualDepositNotificationEmail = ManualDepositNotificationEmail()
    let transferToBankNotificationEmail = TransferToBankNotificationEmail()
    
    fileprivate func convertToDictionary(text: String) -> [String: String]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    func sendRequests() {
        for request in requests {
            guard let mailType = request["mailType"], let email = request["email"], let payload = request["payload"] else { continue }
            var emailContent: String?
            guard let param = convertToDictionary(text: payload) else { continue }
            if mailType == "ManualDepositNotificationEMail" {
                emailContent = manualDepositNotificationEmail.makeEmail(param: param)
            } else if mailType == "DailyDepositNotificationEMail" {
                emailContent = dailyDepositNotificationEmail.makeEmail(param: param)
            } else if mailType == "TransferToBankNotificationEMail" {
                emailContent = transferToBankNotificationEmail.makeEmail(param: param)
            }
            if let emailContent = emailContent {
                if let id = request["id"] {
                    sendEmail(emailAddress: email, content: emailContent, id: id)
                }
            }
        }
    }
    
    func sendEmail(emailAddress: String, content: String, id: String) {
        let client = SMTPClient(url: "smtps://email-smtp.us-east-1.amazonaws.com:465", username: "AKIAIAXEU3ZBOAINAM6Q", password:"AmWMH29ZVyAmkCCXobN7eJlzHLB3kJ0U7Pasqi3xNjEI")
        var email = EMail(client: client)
        email.subject = "Tortoise Notification"
        email.from = Recipient(name: "Tortoise Help", address: "help@newtortoise.com")
        email.content = content
        email.to.append(Recipient(address: emailAddress))
        
        do {
            try email.send { code, header, body in
                print("response code: \(code)")
                print("response header: \(header)")
                print("response body: \(body)")
                if code == 0 {
                    self.completeRequest(id: id)
                }
            }
        } catch(let err) {
            print("Failed to send: \(err)")
        }
    }
}
