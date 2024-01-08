//
//  HashExtension.swift
//  Marvel3.0
//
//  Created by Jorge Abalo Dieste on 21/12/23.
//


import Foundation
import UIKit
import CryptoKit

// Función para calcular el hash MD5

extension String {
    var md5: String {
        let data = Data(self.utf8)
        let digest = Insecure.MD5.hash(data: data)
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}

