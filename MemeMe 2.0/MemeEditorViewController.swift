//
//  MemeEditorViewController.swift.swift
//  MemeMe 2.0
//
//  Created by Abdullah AlBargi on 10/6/19.
//  Copyright © 2019 Abdullah AlBargi. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: Outlets
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    // MARK: Vars
    var defaultTopString = "TOP"
    var defaultBottomString = "BOTTOM"
    var currentTextField: UITextField!
    var selectedImage: UIImage?
    var imagePicker = UIImagePickerController()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        reset()
        
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        cameraButton.isEnabled = UIImagePickerController.isCameraDeviceAvailable(.rear)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeToKeyboardNotifications()
    }

    // MARK: Actions
    @IBAction func sharePressed(_ sender: Any) {
        if let image = takeScreenshot() {
            let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            activity.completionWithItemsHandler = {(_, completed, _, _) in
                if completed {
                    self.save(image)
                    self.dismiss(animated: true, completion: nil)
                }
            }
            present(activity, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
       dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraPressed(_ sender: Any) {
        imagePicker.sourceType = .camera
        showImagePicker()
    }
    
    @IBAction func albumPressed(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        showImagePicker()
    }
    
    // MARK: Helpers
    private func reset() {
        selectedImage = nil
        imageView.image = nil
               configureTextField(topTextField, with: defaultTopString)
               configureTextField(bottomTextField, with: defaultBottomString)
        shareButton.isEnabled = false
        view.endEditing(true)
    }
    
    private func hideToolbar(hide: Bool) {
        navigationController?.toolbar.isHidden = hide
        toolbar.isHidden = hide
    }
    
    private func takeScreenshot() -> UIImage? {
        if selectedImage == nil {
            return nil
        }
        
        hideToolbar(hide: true)
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        hideToolbar(hide: false)
        
        return image
    }
    
    private func configureTextField(_ textField: UITextField, with text: String) {
        
        let paragarghStyle = NSMutableParagraphStyle()
        paragarghStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle:  paragarghStyle,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -2
        ]
        
        textField.defaultTextAttributes = attributes
        textField.text = text
        textField.delegate = self
    }
    
    private func showImagePicker() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWIllShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWIllShow(notification: NSNotification) {
        if currentTextField == topTextField {
            return
        }
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardSize = keyboardFrame.cgRectValue
            view.frame.origin.y = -keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    private func save(_ memeImage: UIImage) {
                
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: selectedImage!, memeImage: memeImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
}


// MARK: Extenstions
extension MemeEditorViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        selectedImage = image
        imageView.image = selectedImage
        shareButton.isEnabled = true
    }
}

extension MemeEditorViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
