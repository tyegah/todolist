//
//  ImageToastData.swift
//  ToDoList
//
//  Created by Ty Septiani on 01/08/23.
//

import Foundation

struct ImageToastData {
    let imageName: String
    let message: String
    let isError: Bool
    let duration: TimeInterval
    let completion: () -> Void
    
    init(imageName: String,
         message: String,
         isError: Bool,
         duration: TimeInterval = 3.0,
         completion: @escaping () -> Void) {
        self.imageName = imageName
        self.message = message
        self.isError = isError
        self.duration = duration
        self.completion = completion
    }
}

extension ImageToastData {
    static func error(message: String, completion: @escaping () -> Void) -> ImageToastData {
        ImageToastData(imageName: "xmark.circle.fill",
                       message: message,
                       isError: true,
                       completion: completion)
    }
}
