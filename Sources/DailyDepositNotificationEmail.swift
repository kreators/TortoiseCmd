
import Foundation

struct DailyDepositNotificationEmail {
    func makeEmail(param: [String:String]) -> String? {
        let emailTemplate = "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\"><html xmlns=\"http://www.w3.org/1999/xhtml\"><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"><meta name=\"viewport\" content=\"width=device-width\"><title>You have a new support message</title></head><body style=\"\"><table class=\"body\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" style=\"width:520px\"><tbody><tr><td style=\"text-align:center; background:#3ab493\"><img src=\"https://s3.amazonaws.com/tortoiseimage/Logo_banner.png\" width=\"480\" height=\"180\"></td></tr><tr><td style=\"padding:40px 0 0 58px; \"><p style=\"padding:0; margin:0; font-size:18px; color:#1b1b1b\"><b>Bank Transfer Initiated</b></p><p style=\"padding:0; margin:0; padding-bottom:50px; font-size:12px; color:#3c3c3c;\">#DATETRANSFERINITIATED#</p><p style=\"padding:0; margin:0; font-size:12.5px; letter-space:0.4; color:#1f1f1f;\">TRANSFER AMOUNT</p><p style=\"padding:0 0 23px; margin:0; font-size:18px; color:#1b1b1b; font-weight:bold\">#TRANSFERAMOUNT#</p><p style=\"padding:0; margin:0; font-size:11px;\">ESTMATED ARRIVAL</p><p style=\"padding:0 0 23px; margin:0; font-size:18px; color:#1b1b1b; font-weight:bold\">#DATEARRIVAL#</p><p style=\"padding:0; margin:0; font-size:12px; line-height:20px; color:#797979;\">Bank transfers initiated before 7 . PM. ET. on business days will</br>typically be abailable in your bank account the next business day.</br>Business days are Mon-Fi, excluding bank holidays.</p></td></tr><tr><td style=\"text-align:center\"><img src=\"https://s3.amazonaws.com/tortoiseimage/dotline_1.png\" width=\"447\" height=\"2\"><p style=\"padding:20px 0 10px 58px; margin:0;font-size:18px; text-align:left; color:#1b1b1b; font-weight:bold\">Your Transaction ID is #TRANSACTIONID#</p><img src=\"https://s3.amazonaws.com/tortoiseimage/dotline_1.png\" width=\"447\" height=\"2\"></td></tr><tr><td><p style=\"padding:27px 0 70px 58px; margin:0; font-size:12px; color:#797979;\">For help and suppor, please call us at [917]688-9851 or email<span style=\"display:block\">help@newtortoise.com.</span></p></td></tr><tr><td style=\"padding:40px 30px 75px; border-top:4px solid #f4f4f4; border-bottom:15px solid #3ab493; font-size:12px; line-height:20px; color:#1b1b1b; \"><p style=\"padding:0; margin:0\">Payment Disclosure : Payments will show up as \"KREATORS, INC\" on your bank statement</p><p style=\"padding:0; margin:0\">Payment instructions are sent via our payment partner, Synapse Finacial</p><p style=\"padding:0; margin:0\">Technologies, inc, and are processed by Triumph Bank.</p><p style=\"padding:0; margin:0\">To report complaints email issues@synpsepay.com.</p></td></tr></tbody></table></body></html>"
        
        guard let transactionId = param["transactionId"], let timezone = param["timezone"], let currency = param["currency"], let amount = param["amount"] else { return nil }
        
        let currencySymbol = currency == "USD" ? "$" : ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = TimeZone(identifier: timezone)
        let timeZoneDescription = TimeZone(identifier: timezone)?.localizedName(for: .standard, locale: .current) ?? ""
        
        let emailContent = emailTemplate.replacingOccurrences(of: "#DATETRANSFERINITIATED#", with: "\(dateFormatter.string(from: Date())) \(timeZoneDescription)").replacingOccurrences(of: "#TRANSFERAMOUNT#", with: "\(currencySymbol)\(amount)").replacingOccurrences(of: "#DATEARRIVAL#", with: "Next 2-3 business day").replacingOccurrences(of: "#TRANSACTIONID#", with: transactionId)
        return emailContent
    }
}
