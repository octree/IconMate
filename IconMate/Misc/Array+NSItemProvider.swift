import Foundation

extension Array where Element == NSItemProvider {
    private func providers(with predicate: (Element) -> Bool, firstOnly: Bool = false) -> Self {
        if !firstOnly {
            return filter(predicate)
        } else {
            if let provider = self.first(where: predicate) {
                return [provider]
            } else {
                return []
            }
        }
    }

    public func loadObjects<T>(ofType theType: T.Type, firstOnly: Bool = false, using load: @escaping ([T
    ]) -> Void) -> Bool where T: NSItemProviderReading {
        let providers = self.providers(with: { $0.canLoadObject(ofClass: theType) }, firstOnly: firstOnly)
        guard providers.count > 0 else {
            return false
        }
        var result = [T]()
        let group = DispatchGroup()
        providers.forEach { provider in
            group.enter()
            provider.loadObject(ofClass: theType) { object, _ in
                if let object = object as? T {
                    result.append(object)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            if result.count > 0 {
                load(result)
            }
        }
        return true
    }
    public func loadObjects<T>(ofType theType: T.Type, firstOnly: Bool = false, using load: @escaping ([T]) -> Void) -> Bool where T: _ObjectiveCBridgeable, T._ObjectiveCType: NSItemProviderReading {
        let providers = self.providers(with: { $0.canLoadObject(ofClass: theType) }, firstOnly: firstOnly)
        guard providers.count > 0 else {
            return false
        }
        var result = [T]()
        let group = DispatchGroup()
        providers.forEach { provider in
            group.enter()
            _ = provider.loadObject(ofClass: theType) { object, _ in
                if let object = object {
                    result.append(object)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            if result.count > 0 {
                load(result)
            }
        }
        return true
    }
    public func loadFirstObject<T>(ofType theType: T.Type, using load: @escaping (T) -> Void) -> Bool where T: NSItemProviderReading {
        self.loadObjects(ofType: theType, firstOnly: true) { result in
            load(result.first!)
        }
    }

    public func loadFirstObject<T>(ofType type: T.Type, using load: @escaping (T) -> Void) -> Bool where T: _ObjectiveCBridgeable, T._ObjectiveCType: NSItemProviderReading {
        return loadObjects(ofType: type, firstOnly: true) {
            load($0.first!)
        }
    }
}
