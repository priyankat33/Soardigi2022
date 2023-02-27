//
//  StaticContentVC.swift
//  Soardigi
//
//  Created by Developer on 15/01/23.
//

import UIKit
import WebKit
class StaticContentVC: UIViewController {
    var heading:String = ""
    var urlString:String = ""
    var isFromFeed:Bool = false
    fileprivate var homeViewModel:HomeViewModel = HomeViewModel()
    @IBOutlet weak var webView:WKWebView!
    @IBOutlet weak var headingLBL:UILabel!
    private var isInjected: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFromFeed {
            headingLBL.text = heading
            
            let url = URL(string: urlString)!

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = ServerManager.shared.apiHeaders
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    let font = "<font face='Montserrat-Regular' size='11' color= 'black'>%@"
                    
                    let html = String(data:data, encoding: .utf8)
                    let html1 = String(format: font, html!)
                    DispatchQueue.main.async {
                        self.webView.loadHTMLString(html1, baseURL: nil)
                    }
                    
                } else if let error = error {
                    print("HTTP Request Failed \(error)")
                }
            }

            task.resume()
            
//            let config = URLSessionConfiguration.default
//            let session = URLSession(configuration: config)
//
//            if let url = NSURL(string: urlString) {
//
//                let task = session.dataTask(with: url as URL, completionHandler: {data, response, error in
//
//                    if let err = error {
//                        print("Error: \(err)")
//                        return
//                    }
//                    showLoader()
//                    if let http = response as? HTTPURLResponse {
//                        if http.statusCode == 200, let dataString = String(data: data!, encoding: .utf8) {
//                            let value = dataString.html2String
//
//                        }
//                    }
//               })
//               task.resume()
//            }
 
        } else {
            headingLBL.text = heading
            let url = URL(string: urlString)
            let request = URLRequest(url: url!)
            webView.navigationDelegate = self
            webView.load(request)
        }
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



extension StaticContentVC: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        showLoader(status: true)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showLoader(status: false)
        if isInjected == true {
                return
            }
            self.isInjected = true
        let js = "document.body.outerHTML"
        webView.evaluateJavaScript(js) { (html, error) in
            let headerString = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head>"
            webView.loadHTMLString(headerString + (html as! String), baseURL: nil)
        }
    }
        
   
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        showLoader(status: false)
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
