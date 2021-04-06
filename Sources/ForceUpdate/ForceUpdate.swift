import Foundation
import FirebaseRemoteConfig

public enum ForceUpdateError: LocalizedError {
    
    case notActivated
    case parsingError
    case requiredUpdate(String)
    case recommendedUpdate(String)
}

public enum Key: String {
    
    case force_update_required
    case force_update_current_version
    case force_update_store_url
}

public struct ForceUpdate {
    
    let config: RemoteConfig
    
    public init(_ config: RemoteConfig) {
        self.config = config
    }
    
    public func startTracking(completion: @escaping (Result<Void, ForceUpdateError>) -> Void) {
        config.fetch() { status, error -> Void in
            if status == .success {
                self.activate(completion: completion)
            } else {
                DispatchQueue.main.async {
                    completion(.failure(.notActivated))
                }
            }
        }
    }
    
    private func activate(completion: @escaping (Result<Void, ForceUpdateError>) -> Void) {
        self.config.activate() { changed, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.notActivated))
                }
                return
            }
            
            let isRequired = self.config.configValue(forKey: Key.force_update_required.rawValue).boolValue
            
            if let boundleVersionS = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
               let currentVersionS = self.config.configValue(forKey: Key.force_update_current_version.rawValue).stringValue,
               let storeUrl = self.config.configValue(forKey: Key.force_update_store_url.rawValue).stringValue
            {
                let appVersion = Version(boundleVersionS)
                let currentVersion = Version(currentVersionS)
                
                if appVersion < currentVersion {
                    if isRequired {
                        DispatchQueue.main.async {
                            completion(.failure(.requiredUpdate(storeUrl)))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(.recommendedUpdate(storeUrl)))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(.parsingError))
                }
            }
        }
    }
}
