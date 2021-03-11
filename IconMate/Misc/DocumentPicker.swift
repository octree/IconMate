import UIKit
import UniformTypeIdentifiers

public class DocumentPickerViewController: UIDocumentPickerViewController {
    private let onDismiss: () -> Void
    private let onPick: ([URL]) -> Void

    public init(supportedTypes: [String],
                mode: UIDocumentPickerMode = .import,
                onPick: @escaping ([URL]) -> Void,
                onDismiss: @escaping () -> Void = {}) {
        self.onDismiss = onDismiss
        self.onPick = onPick

        super.init(documentTypes: supportedTypes, in: mode)
        delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DocumentPickerViewController: UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        onPick(urls)
    }

    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        onDismiss()
    }
}
