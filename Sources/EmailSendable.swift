
import Foundation
import PerfectLib
import MySQL

protocol EmailSendable {
    var mysql: MySQL { get }
    var requests: [[String:String]] { get set }
    func connectDB() -> Bool
    mutating func queryRequests()
    func sendEmail(emailAddress: String, content: String, id: String)
    func completeRequest(id: String)
}

extension EmailSendable {
    func connectDB() -> Bool {
        let connected = mysql.connect(host: "tortoisedb.cgk0b55tapo1.us-east-1.rds.amazonaws.com", user: "root", password: "Saturn!07", db: "TORTOISE")
        guard connected else {
            print("\(#function) : \(mysql.errorMessage())")
            return false
        }
        return true
    }
    
    func creatRequest() {
        let recipient = "define68@gmail.com"
        let mailType = "ManualDepositNotificationMail"
        let dic = ["userId":"111", "amount":"10.12"]
        do {
            let data = try JSONSerialization.data(withJSONObject: dic, options: [])
            guard let payload = String(data: data, encoding:.utf8) else { return }
            let insertQuery = "INSERT INTO SendMailQueue (recipient, mailType, payload, dateCreated) VALUES ('\(recipient)', '\(mailType)', '\(payload)', NOW())"
            let querySuccess = mysql.query(statement: insertQuery)
            guard querySuccess else {
                print("\(#function) : \(mysql.errorMessage())")
                return
            }
        } catch {
            print("\(#function) : JSONSerialization")
        }
    }
    
    mutating func queryRequests() {
        let querySuccess = mysql.query(statement: "SELECT Mail.id, recipient, SPemail, mailType, payload FROM SendMailQueue Mail JOIN SPUser User ON Mail.recipient = User.SPid WHERE dateSent IS NULL ORDER BY Mail.dateCreated DESC LIMIT 100")
        guard querySuccess else {
            print("\(#function) : \(mysql.errorMessage())")
            return
        }
        self.requests.removeAll()
        
        var id: String?
        var recipient: String?
        var email: String?
        var mailType: String?
        var payload: String?
        
        let results = mysql.storeResults()!
        while let row = results.next() {
            id = row[0]
            recipient = row[1]
            email = row[2]
            mailType = row[3]
            payload = row[4]
            
            var request = [String:String]()
            if let id = id {
                request["id"] = id
            }
            if let recipient = recipient {
                request["recipient"] = recipient
            }
            if let email = email {
                request["email"] = email
            }
            if let mailType = mailType {
                request["mailType"] = mailType
            }
            if let payload = payload {
                request["payload"] = payload
            }
            self.requests.append(request)
        }
        results.close()
    }

    func completeRequest(id: String) {
        let querySuccess = mysql.query(statement: "UPDATE SendMailQueue SET dateUpdated = NOW(), dateSent = NOW() WHERE id = '\(id)'")
        guard querySuccess else {
            print("\(#function) : \(mysql.errorMessage())")
            return
        }
    }
}
