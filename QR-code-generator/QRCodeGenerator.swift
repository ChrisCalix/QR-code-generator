//
//  QRCodeGenerator.swift
//  QR-code-generator
//
//  Created by Christian Calixto on 27/2/23.
//

import CoreImage.CIFilterBuiltins
import UIKit

struct QRCodeGenerator {

    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()

    public func generateQRCode(for url: String) -> QRCode? {
        guard !url.isEmpty else { return nil }

        let data = Data(url.utf8)
        filter.setValue(data, forKey: "inputMessage")

        let trasnfrom = CGAffineTransform(scaleX: 10, y: 10)

        guard let outpurImage = filter.outputImage?.transformed(by: trasnfrom),
              let cgImage = context.createCGImage(outpurImage, from: outpurImage.extent) else {
            return nil
        }

        let qrCode = QRCode(urlString: url, uiImage: UIImage(cgImage: cgImage))
        return qrCode
    }
}

struct QRCode {
    let urlString: String
    let uiImage: UIImage
}
