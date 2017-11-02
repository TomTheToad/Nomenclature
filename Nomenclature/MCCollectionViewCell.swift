//
//  MCCollectionViewCell.swift
//  Nomenclature
//
//  Created by VICTOR ASSELTA on 9/17/17.
//  Copyright © 2017 TomTheToad. All rights reserved.
//

import UIKit

class MCCollectionViewCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    
    // Organism
    var receivedCard: OrganismCard?
    private var card: OrganismCard {
            get {
            guard let thisCard = receivedCard else {
                // TODO: do something better
                fatalError("card missing")
            }
            return thisCard
        }
    }
    
    /* Table Methods */
    @IBOutlet weak var cellTableView: UITableView!

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return card.dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell") as! ImageCell
            cell.organismImageView.contentMode = .scaleAspectFit

            guard let photo = card.photo else {
                cell.organismImageView.image = #imageLiteral(resourceName: "missingImage")
                return cell
            }

            guard let image = photo.image else {
                cell.organismImageView.image = #imageLiteral(resourceName: "missingImage")
                return cell
            }
            
            cell.organismImageView.image = image
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "nomenCell", for: indexPath) as! NomenCell
        let data = card.dataSource[indexPath.row]
        cell.classification.text = data.cellHeading
        cell.name.text = data.cellContent
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return CGFloat(200)
        }
        return CGFloat(40)
    }

}
