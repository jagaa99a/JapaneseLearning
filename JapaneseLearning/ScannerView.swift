import SwiftUI
import VisionKit
import Vision

struct ScannerView: UIViewControllerRepresentable {
    var onScanCompleted: ([String]) -> Void

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = context.coordinator
        return scanner
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(onScanCompleted: onScanCompleted)
    }

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var onScanCompleted: ([String]) -> Void

        init(onScanCompleted: @escaping ([String]) -> Void) {
            self.onScanCompleted = onScanCompleted
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
          _ = [String]()

            let requestHandler = VNImageRequestHandler(cgImage: scan.imageOfPage(at: 0).cgImage!, options: [:])
          let request = VNRecognizeTextRequest { [weak self] (request, error) in
              guard let self = self else { return }
              guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
              let recognizedText = observations.compactMap { $0.topCandidates(1).first?.string }
              self.onScanCompleted(recognizedText)
          }

            request.recognitionLevel = .accurate

            do {
                try requestHandler.perform([request])
            } catch {
                print("Error recognizing text: \(error)")
            }

            controller.dismiss(animated: true)
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true)
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Camera failed with error: \(error)")
            controller.dismiss(animated: true)
        }
    }
}
