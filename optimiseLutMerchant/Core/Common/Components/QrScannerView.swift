//
//  QrScannerView.swift
//  optimiseLutMerchant
//
//  Created by Ritesh Parekh on 01/09/25.
//

import AVFoundation
import SwiftUI

struct QRScannerView: UIViewRepresentable {
    class ScannerView: UIView {
        var captureSession: AVCaptureSession?
        var onDetected: ((String) -> Void)?

        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        private var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            layer as! AVCaptureVideoPreviewLayer
        }

        func setupScanner(onDetected: @escaping (String) -> Void) {
            self.onDetected = onDetected
            let session = AVCaptureSession()
            guard let device = AVCaptureDevice.default(for: .video),
                let input = try? AVCaptureDeviceInput(device: device)
            else { return }

            if session.canAddInput(input) { session.addInput(input) }

            let metadataOutput = AVCaptureMetadataOutput()
            if session.canAddOutput(metadataOutput) {
                session.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(
                    self, queue: DispatchQueue.main
                )
                metadataOutput.metadataObjectTypes = [.qr]
            }

            videoPreviewLayer.session = session
            videoPreviewLayer.videoGravity = .resizeAspectFill
            captureSession = session

            DispatchQueue.global(qos: .userInitiated).async {
                session.startRunning()
            }
        }

    }

    var onDetected: (String) -> Void

    func makeUIView(context: Context) -> ScannerView {
        let view = ScannerView()
        view.setupScanner(onDetected: onDetected)
        return view
    }

    func updateUIView(_ uiView: ScannerView, context: Context) {}
}

extension QRScannerView.ScannerView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard
            let object = metadataObjects.first
                as? AVMetadataMachineReadableCodeObject,
            let value = object.stringValue
        else { return }
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        onDetected?(value)
    }
}
