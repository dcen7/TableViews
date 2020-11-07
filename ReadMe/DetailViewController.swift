//
//  DetailViewController.swift
//  ReadMe
//
//  Created by Mehmet Deniz Cengiz on 11/2/20.
//  Copyright © 2020 Deniz Cengiz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    let book: Book
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authourLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func updateImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    override func viewDidLoad() {
        imageView.image = book.image
        imageView.layer.cornerRadius = 16
        titleLabel.text = book.title
        authourLabel.text = book.author
    }
    
    required init?(coder: NSCoder) {
        fatalError("This should never be called")
    }
    
    init?(coder: NSCoder, book: Book) {
        self.book = book
        super.init(coder: coder)
    }
}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        imageView.image = selectedImage
        Library.saveImage(selectedImage, forBook: book)
        dismiss(animated: true)
    }
}
