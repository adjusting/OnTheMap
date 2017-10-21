//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Justin Gareau on 9/7/17.
//  Copyright © 2017 Justin Gareau. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitLogin(_ sender: Any) {
        passwordField.resignFirstResponder()
        usernameField.resignFirstResponder()
        let session = URLSession.shared
        let request = loginRequest()
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                self.presentError(error!.localizedDescription)
                return
            }
            do {
                let range = Range(5..<data!.count)
                let newData = data?.subdata(in: range) /* subset response data! */
                let parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as AnyObject
                if let errorString = parsedResult.value(forKey: "error") as? String {
                    self.presentError(errorString)
                } else {
                    print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
                    self.performSegue(withIdentifier: "successSegue", sender: self)
                }
            } catch {
                print("Error")
            }
        }
        task.resume()
    }

    func loginRequest() -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(usernameField.text!)\", \"password\": \"\(passwordField.text!)\"}}".data(using: String.Encoding.utf8)
        return request
    }
    
    func presentError(_ errorString: String) {
        let alert = UIAlertController(title: "Error", message:errorString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default Action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    @IBAction func signUp(sender: AnyObject) {
        if let url = URL(string: "https://www.udacity.com/account/auth#!/signup"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
}

