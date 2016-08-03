//
//  LegalPage.swift
//  ChoreMastr
//
//  Created by Demetri Kostakis on 4/15/16.
//  Copyright © 2016 ChoreMastr. All rights reserved.
//
//  Legal page has information that may be relavent to the user regarding use, privacy, and other legal information.

import UIKit

class LegalPage: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var fileName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //locates file in the main bundle
        let filePath = NSBundle.mainBundle().URLForResource(fileName, withExtension: "rtfd")!
        do {
            textView.attributedText = try NSAttributedString(fileURL: filePath, options: [NSDocumentTypeDocumentAttribute:NSRTFDTextDocumentType], documentAttributes: nil)
        }
        catch {/* error handling here */}
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
