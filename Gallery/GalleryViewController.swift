//
//  ViewController.swift
//  Gallery
//
//  Created by Олег Овечкин on 21/04/2017.
//  Copyright © 2017 Spent. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

    lazy var dataSource = DataSourceBuilder.sample()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
    }

    func reloadDataSource(withSearch string: String?) {
        print("\(string ?? "empty")")
    }
    
    func didSelectItem(atIndex index: Int) {
        print("item selected \(index)")
    }
}


extension GalleryViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.reuseIdentifier, for: indexPath) as! GalleryCell
        
        let item = dataSource[indexPath.row]
        cell.imageView.image = item.image
        
        return cell
    }
}


extension GalleryViewController: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem(atIndex: indexPath.row)
    }
}


extension GalleryViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = textField.text as NSString?
        let value = text?.replacingCharacters(in: range, with: string)
        
        reloadDataSource(withSearch: value)
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        reloadDataSource(withSearch: nil)
        
        return true
    }
}