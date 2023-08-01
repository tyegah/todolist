//
//  ImageToastView.swift
//  ToDoList
//
//  Created by Ty Septiani on 01/08/23.
//

import SwiftUI

struct ImageToastView: View {
    let toastData: ImageToastData
   
    @State private var showToast = false

    var body: some View {
        VStack {
            Spacer()
            if showToast {
                VStack {
                    if !toastData.imageName.isEmpty {
                        Image(systemName: toastData.imageName)
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                    }
                    
                    Text(toastData.message)
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + toastData.duration) {
                                withAnimation {
                                    showToast = false
                                    toastData.completion()
                                }
                            }
                        }
                }
                .padding()
                .background(toastData.isError ? Color.red : Color.black.opacity(0.8))
                .cornerRadius(8.0)
                .opacity(0.95)
            }
            Spacer()
        }
        .animation(.easeInOut)
        .onAppear {
            showToast = true
        }
    }
}
