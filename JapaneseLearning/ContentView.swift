import SwiftUI

struct ContentView: View {
    @State private var showScanner = false
    @State private var scannedText: [String] = []

    var body: some View {
        VStack {
            Button("Scan Text") {
                showScanner = true
            }
            .padding()
            .buttonStyle(.borderedProminent)

            List(scannedText, id: \.self) { text in
                Text(text)
            }
        }
        .sheet(isPresented: $showScanner) {
            // ✅ FIX: Provide the required closure
            ScannerView { scannedResult in
                scannedText = scannedResult
                showScanner = false // Close the sheet after scanning
            }
        }
    }
}

#Preview {
    ContentView()
}
