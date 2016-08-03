//
//  Backblaze.swift
//  ChoreMastr
//
//  Created by Demetri Kostakis on 4/16/16.
//  Copyright © 2016 ChoreMastr. All rights reserved.
//

import Foundation

class Backblaze: NSObject {
    
    func <#name#>(<#parameters#>) -> <#return type#> {
        <#function body#>
    }
    var accountId = "ACCOUNT_ID" // Obtained from your B2 account page.
    var applicationKey = "APPLICATION_KEY" // Obtained from your B2 account page.
    if let url = NSURL(string: "https://api.backblaze.com/b2api/v1/b2_authorize_account") {
        let base64Str = "\(accountId):\(applicationKey)".dataUsingEncoding(NSUTF8StringEncoding)!.base64EncodedStringWithOptions(.Encoding76CharacterLineLength)
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.addValue("Basic \(base64Str)", forHTTPHeaderField: "Authorization"))
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration());
        let task = session.dataTaskWithRequest(request, completionHandler:{(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if data != nil {
                let json = NSString(data: data!, encoding:NSUTF8StringEncoding)
                print(json)
            }
        })
        task.resume()
    }
}