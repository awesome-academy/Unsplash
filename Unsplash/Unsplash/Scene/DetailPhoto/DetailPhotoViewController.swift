//
//  DetailPhotoViewController.swift
//  Unsplash
//
//  Created by Nha Pham on 9/1/20.
//  Copyright © 2020 Nha Pham. All rights reserved.
//

import UIKit
import Kingfisher
import imglyKit

protocol DetailPhotoDelegate: class {
    func viewDidDisapear(_ viewController: UIViewController)
    func startEditPhoto(editorCompletionBlock: @escaping IMGLYEditorCompletionBlock, imageView: UIImageView)
    func showAlertWith(title: String, message: String)
}

class DetailPhotoViewController: UIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var downloadButtonn: UIButton!
    @IBOutlet private weak var pinButton: UIButton!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var loading: UIActivityIndicatorView!
    weak var delegate: DetailPhotoDelegate?
    private var isHideButton = false
    private var isDoubleTapZoom = false
    private var isPined = false
    var photo: Photo!
    private let viewModel = DetailPhotoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        loading.hidesWhenStopped = true
        loading.startAnimating()
        checkPhotoIsPined()
        setupViews()
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
    }

    private func setupViews() {
        
        downloadButtonn.isEnabled = false
        editButton.isEnabled = false
        pinButton.isEnabled = false
        
        if let imagePath = photo.urls?.full {
            imageView.kf.setImage(with: imagePath, placeholder: nil, options: nil, progressBlock: nil) { [weak self] (_, _, _, _) in
                self?.downloadButtonn.isEnabled = true
                self?.editButton.isEnabled = true
                self?.pinButton.isEnabled = true
                self?.loading.stopAnimating()
            }
        }

        // set up scroll view
        scrollView.backgroundColor = .black
        view.backgroundColor = .black
        scrollView.isScrollEnabled = false
        scrollView.frame = view.bounds
        scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        // implement double tap for image view
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapResizeImage))
        doubleTap.numberOfTouchesRequired = 1
        doubleTap.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTap)
        
        // implement if user tap screen all button will disapear
        
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(startHideButton))
        tapScreen.numberOfTapsRequired = 1
        tapScreen.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(tapScreen)
        
        // set up download button
        downloadButtonn.layer.cornerRadius = downloadButtonn.frame.size.width / 2
        downloadButtonn.clipsToBounds = true
        downloadButtonn.addTarget(self, action: #selector(downloadImage), for: .touchUpInside)
        
        // set up pin image
        setPinImage()
        pinButton.layer.cornerRadius = pinButton.frame.size.width / 2
        pinButton.clipsToBounds = true
        pinButton.addTarget(self, action: #selector(pinAction), for: .touchUpInside)
        
        // set up edit button
        editButton.addTarget(self, action: #selector(editAcion), for: .touchUpInside)
        editButton.layer.cornerRadius = pinButton.frame.size.width / 2
        
        // set up cancel button
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
    }
    
    @objc func doubleTapResizeImage() {
        if isDoubleTapZoom {
            scrollView.zoomScale = 1.0
            isDoubleTapZoom = false
        } else {
            scrollView.zoomScale = 1.7
            isDoubleTapZoom = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear (_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        delegate?.viewDidDisapear(self)
    }
    
    private func setPinImage() {
        if isPined {
            pinButton.setImage(UIImage(named: "pin"), for: .normal)
        } else {
            pinButton.setImage(UIImage(named: "unpin"), for: .normal)
        }
    }
    
    // MARK: animation button
    
    private func moveLeft(object: UIView) {
        object.frame.origin.x += view.frame.size.width
    }
    private func moveRight(object: UIView) {
         object.frame.origin.x -= view.frame.size.width
    }

    @objc private func startHideButton() {
        if isHideButton {
            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .beginFromCurrentState, animations: {
                self.moveRight(object: self.downloadButtonn)
                self.moveRight(object: self.pinButton)
                self.moveRight(object: self.editButton)
                self.moveLeft(object: self.cancelButton)
                self.isHideButton = false
            })
        } else {
            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .beginFromCurrentState, animations: {
                self.moveLeft(object: self.downloadButtonn)
                self.moveLeft(object: self.pinButton)
                self.moveLeft(object: self.editButton)
                self.moveRight(object: self.cancelButton)
                self.isHideButton = true
            })
        }
    }
    
    // MARK: button action
    @objc private func editAcion() {
        delegate?.startEditPhoto(editorCompletionBlock: self.editorCompletionBlock(result:image:), imageView: imageView)
    }
    
    @objc private func cancelAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func pinAction() {
        if !isPined {
            viewModel.addPhotoToStore(imageId: photo.id)
            isPined = true
            setPinImage()
        } else {
            viewModel.removePhotoFromStore(imageId: photo.id)
            isPined = false
            setPinImage()
        }
    }
    
    // MARK: editor result
    func editorCompletionBlock(result: IMGLYEditorResult, image: UIImage?) {
        switch result {
        case .done:
            if let image = image {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        case .cancel:
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func downloadImage() {
        guard let image = imageView.image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    private func checkPhotoIsPined() {
        isPined = viewModel.isObjectExist(id: photo.id)
    }
    
    // MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            delegate?.showAlertWith(title: "Save error", message: "Save error")
            print(error.localizedDescription)
        } else {
            delegate?.showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
}

// MARK: handle zoom image
extension DetailPhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollView.isScrollEnabled = true
        if scrollView.zoomScale == 1.0 {
             scrollView.isScrollEnabled = false
        }
    }
}

// MARK: setup view for edit screen
extension IMGLYEditorViewController {
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
        navigationController?.navigationItem.rightBarButtonItem = saveItem
    }
}
