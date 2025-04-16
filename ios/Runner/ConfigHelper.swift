import Foundation

enum Environment: String {
    case development = "development"
    case staging = "staging"
    case production = "production"
    
    var appName: String {
        switch self {
        case .development:
            return "Manage Salary Dev"
        case .staging:
            return "Manage Salary Staging"
        case .production:
            return "Manage Salary"
        }
    }
    
    var bundleIdentifier: String {
        switch self {
        case .development:
            return "id.thangpn.manage-salary.dev"
        case .staging:
            return "id.thangpn.manage-salary.stg"
        case .production:
            return "id.thangpn.manage-salary"
        }
    }
}

@objc class ConfigHelper: NSObject {
    static let shared = ConfigHelper()
    
    var environment: Environment {
        #if DEVELOPMENT
            return .development
        #elseif STAGING
            return .staging
        #else
            return .production
        #endif
    }
    
    @objc static func getAppName() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "Manage Salary"
    }
    
    @objc static func getAppVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
    }
    
    @objc static func getAdsKey() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "FLUTTER_ADS_KEY") as? String ?? ""
    }
    
    @objc static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
}