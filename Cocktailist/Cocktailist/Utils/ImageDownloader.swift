//
//  ImageDownloader.swift
//  Cocktailist
//
//  Created by Mauricio Chirino on 25/2/18.
//  Copyright © 2018 Mauricio Chirino. All rights reserved.
//

import UIKit

typealias ImageLoadOperationCompletionHandlerType = ((UIImage) -> ())?

class ImageLoadOperation: Operation {
    var url: URL
    var completionHandler: ImageLoadOperationCompletionHandlerType
    var image: UIImage?
    
    init(url: URL) {
        self.url = url
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        UIImage.downloadImageFromUrl(url) { [weak self] (image) in
            guard let strongSelf = self,
                !strongSelf.isCancelled,
                let image = image else {
                    return
            }
            strongSelf.image = image
            strongSelf.completionHandler?(image)
        }
    }
}

extension UIImage {
    static func downloadImageFromUrl(_ url: URL, completionHandler: @escaping (UIImage?) -> Void) {
        guard let fixedURL = URL(string: "http://\(url.absoluteURL)") else { return }
        print(fixedURL)
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: fixedURL, completionHandler: { (data, response, error) -> Void in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data) else {
                    completionHandler(nil)
                    return
            }
            completionHandler(image)
        })
        task.resume()
    }
}

extension UIImageView {
    func setImage(_ image: UIImage?) {
        guard let image = image else { return }
        DispatchQueue.main.async { [weak self]  in
            guard let strongSelf = self else { return }
            strongSelf.image = image
        }
    }
}

