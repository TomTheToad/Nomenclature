//
//  DetailViewController.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 8/12/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var organismData = NSDictionary()
    
    // MARK: Required Table Methods
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 1 {
//            return organismData.count
//        } else {
//            return 1
//        }
        return organismData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: find a better way of comparing keys
//        if organismData[indexPath.row] as! String == organismData["commonName"] as! String {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "detailViewImageCell", for: indexPath) as! DetailViewImageCell
//            // TODO: setup cell after prototype created
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "detailViewCell", for: indexPath) as! DetailViewCell
//            // TODO: setup cell after prototype created
//            return cell
//        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailViewCell", for: indexPath) as! DetailViewCell
        guard let recordData = organismData[indexPath.row] as? [String: String] else {
            print("record data failure")
            return cell
        }
        
        let recordString = "\(String(describing: recordData.first?.key)): \(String(describing: recordData.first?.value))"        
        cell.headingLabel.text = recordString
        return cell
    }
}
