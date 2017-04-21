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
    lazy var throttler = SearchThrottler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
    }

    func updateDataSource(withSearch string: String?) {
        
        let text = string ?? "empty"
        print("\(text)")
        
        throttler.execute {
            print("reload with \(text)")
        }
    }
    
    func didSelectItem(atIndex index: Int) {
        
        let item = dataSource[index]
        if let vc = DetailsViewController.instance(withItem: item, storyboard: self.storyboard) {
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
        
        updateDataSource(withSearch: value)
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        updateDataSource(withSearch: nil)
        
        return true
    }
}
