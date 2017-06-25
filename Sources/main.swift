
import Foundation
import PerfectLib
import PerfectThread

var notificationEmail = NotificationEmail()
let success = notificationEmail.connectDB()
while true {
    notificationEmail.queryRequests()
    notificationEmail.sendRequests()
    Threading.sleep(seconds: 10)
}

