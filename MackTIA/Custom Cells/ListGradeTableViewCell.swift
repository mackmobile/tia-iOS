//
//  ListGradeTableViewCell.swift
//  MackTIA
//
//  Created by Joaquim Pessoa Filho on 15/04/16.
//  Copyright © 2016 Mackenzie. All rights reserved.
//

import UIKit

class ListGradeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var formulaLabel: UILabel!
    @IBOutlet weak var ni1CollectionView: UICollectionView!
    @IBOutlet weak var ni2CollectionView: UICollectionView!
    @IBOutlet weak var otherGradesCollectionView: UICollectionView!
    
    let ni1ComponentsKey = ["NI 1","A","B","C","D","E"]
    let ni2ComponentsKey = ["NI 2","F","G","H","I","J"]
    let otherComponentsKey = ["SUB","PARTIC","MI","PF","MF"]
    var grades:[String:String] = [:]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ni1CollectionView.delegate = self
        self.ni1CollectionView.dataSource = self
        self.ni2CollectionView.delegate = self
        self.ni2CollectionView.dataSource = self
        self.otherGradesCollectionView.delegate = self
        self.otherGradesCollectionView.dataSource = self
        
        layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if self.isSelected {
            UIView.animate(withDuration: 0.3, delay: 0.0, options:[], animations: { () -> Void in
                self.contentView.backgroundColor = UIColor(hex: "FAFAFA")
                }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3, delay: 0.0, options:[], animations: { () -> Void in
                self.contentView.backgroundColor = UIColor(hex: "FFFFFF")
                }, completion: nil)
        }
    }
    
    func config(_ grade:Grade) {
        self.classNameLabel.text = grade.className
        self.formulaLabel.text = grade.formula
        self.grades = grade.grades
        
        // Force reload becouse this is a reusable cell
        self.ni1CollectionView.reloadData()
        self.ni2CollectionView.reloadData()
        self.otherGradesCollectionView.reloadData()
    }

}

extension ListGradeTableViewCell: UICollectionViewDelegate {
    
}

extension ListGradeTableViewCell: UICollectionViewDataSource {
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == ni1CollectionView || collectionView == ni2CollectionView {
            return 6
        }
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == ni1CollectionView {
            let key = ni1ComponentsKey[(indexPath as NSIndexPath).row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gradeCell", for: indexPath) as! ListGradeCollectionViewCell
            cell.title.text = key
            cell.value.text = grades[key] ?? "-"
            return cell
        } else if collectionView == ni2CollectionView {
            let key = ni2ComponentsKey[(indexPath as NSIndexPath).row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gradeCell", for: indexPath) as! ListGradeCollectionViewCell
            cell.title.text = key
            cell.value.text = grades[key] ?? "-"
            return cell
        } else if collectionView == otherGradesCollectionView {
            let key = otherComponentsKey[(indexPath as NSIndexPath).row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gradeCell", for: indexPath) as! ListGradeCollectionViewCell
            cell.title.text = key
            cell.value.text = grades[key] ?? "-"
            return cell
        }
        
        return UICollectionViewCell()
    }
}
