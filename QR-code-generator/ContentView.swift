//
//  ContentView.swift
//  QR-code-generator
//
//  Created by Christian Calixto on 26/2/23.
//

import SwiftUI

struct ContentView: View {

    @State private var urlInput: String = ""
    @State private var qrCode: QRCode?

    private let qrCodeGenerator = QRCodeGenerator()

    var body: some View {
        VStack {
            NavigationView {
                GeometryReader { geometry in
                    VStack {
                        HStack {
                            TextField("Enter url", text: $urlInput)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .textContentType(.URL)
                                .keyboardType(.URL)

                            Button("Generate") {
                                UIApplication
                                    .shared
                                    .connectedScenes
                                    .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                                    .first { $0.isKeyWindow }?
                                    .endEditing(true)
                                qrCode = qrCodeGenerator.generateQRCode(for: urlInput)
                                urlInput = String()

                            }
                            .disabled(urlInput.isEmpty)
                            .padding(.leading)
                        }

                        Spacer()

                        if let qrCode {
                            QRCodeView(qrCode: qrCode, width: geometry.size.width)

                        } else {
                            EmptyStateView(width: geometry.size.width)
                        }

                        Spacer()
                    }
                    .padding()
                    .navigationBarTitle("QR Code")

                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: Helper View

struct QRCodeView: View {
    let qrCode: QRCode
    let width: CGFloat

    var body: some View {
        VStack {
            Label("QR code for \(qrCode.urlString)", systemImage: "qrcode.viewfinder")
                .lineLimit(3)
            Image(uiImage: qrCode.uiImage)
                .resizable()
                .frame(width: width * 2 / 3, height: width * 2 / 3)
        }
    }
}

struct EmptyStateView: View {
    let width: CGFloat

    private var imageLength: CGFloat {
        width / 2.5
    }

    var body: some View {
        VStack {
            Image(systemName: "qrcode")
                .resizable()
                .frame(width: imageLength, height: imageLength)

            Text("Create your own QR code")
                .padding(.top)

        }
        .foregroundColor(Color(uiColor: .systemGray))
    }
}
