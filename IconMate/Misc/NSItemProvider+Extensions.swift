import Foundation

extension NSItemProvider {
    public func hasItemConformingToOneOf(typeIdentifiers: [String]) -> Bool {
        for type in typeIdentifiers {
            if hasItemConformingToTypeIdentifier(type) {
                return true
            }
        }
        return false
    }

    @discardableResult
    public func loadObject<T>(ofClass aClass: T.Type, on queue: DispatchQueue, completionHandler: @escaping (T?, Error?) -> Void) -> Progress where T: _ObjectiveCBridgeable, T._ObjectiveCType: NSItemProviderReading {
        loadObject(ofClass: aClass) { obj, err in
            queue.async {
                completionHandler(obj, err)
            }
        }
    }

    @discardableResult
    open func loadObject(ofClass aClass: NSItemProviderReading.Type, on queue: DispatchQueue, completionHandler: @escaping (NSItemProviderReading?, Error?) -> Void) -> Progress {
        loadObject(ofClass: aClass) { (item, error) in
            queue.async {
                completionHandler(item, error)
            }
        }
    }
}
