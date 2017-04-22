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
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
    }

    func updateDataSource(withTag tag: String?) {
        
        let tag = tag ?? "empty"
        throttler.execute {
            print("reload with \(tag)")
            FlickrService.searchPhotos(withTag: tag, completion: { (json) in
                print("\(json ?? "error")")
            })
        }
    }
    
    func didSelectItem(atIndex index: Int) {
        
        let item = dataSource[index]
        if let vc = DetailsViewController.instance(withItem: item, storyboard: self.storyboard) {
            let presenter = {
                self.navigationController?.pushViewController(vc, animated: true)
            }
            if textField.isFirstResponder {
                view.endEditing(true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                    presenter()
                })
            } else {
                presenter()
            }
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
        item.asyncThumbnail { (image) in
            cell.imageView.image = image
        }
        
        return cell
    }
}


extension GalleryViewController: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem(atIndex: indexPath.row)
    }
}


extension GalleryViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let itemsPerRow: CGFloat = 3
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let spacing: CGFloat = 10
        
        let padding = insets.left + insets.right + (itemsPerRow-1) * spacing
        let availableWidth = collectionView.bounds.size.width - padding
        let width = availableWidth / itemsPerRow
        
        return CGSize(width: width, height: width)
    }
}


extension GalleryViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = textField.text as NSString?
        let value = text?.replacingCharacters(in: range, with: string)
        
        updateDataSource(withTag: value)
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        updateDataSource(withTag: nil)
        
        return true
    }
}
