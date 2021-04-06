import Foundation

public struct Version: Codable {
    
    public static var numbers: Int = 3
    
    public var string: String
    
    public var major: Int
    public var minor: Int
    public var patch: Int
    
    public init(_ version: String) {
        let components = Version.normalize(version, toNumber: Version.numbers)
        
        self.major = components[0]
        self.minor = components[1]
        self.patch = components[2]
        self.string =  "\(major).\(minor).\(patch)"
    }
    
    public init(_ version: Version) {
        string = version.string
        major = version.major
        minor = version.minor
        patch = version.patch
    }
    
    public init(_ major: Int, _ minor: Int, _ patch: Int) {
        self.string = "\(major).\(minor).\(patch)"
        self.major = major
        self.minor = minor
        self.patch = patch
    }
    
    private static func normalize(_ version: String, toNumber characters: Int) -> [Int] {
        var components = version
            .split(separator: ".", omittingEmptySubsequences: false)
            .map(String.init)
            .compactMap({ Int($0) })
            .filter({ $0 >= 0 })
        
        let diff = characters - components.count
        
        if diff < 0 {
            components = components.dropLast(abs(diff))
        } else if diff < characters {
            let zeros = Array(repeating: 0, count: abs(diff))
            components.append(contentsOf: zeros)
        }
        
        return components
    }
}

extension Version: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension Version {
    
    public static func == (lhs: Version, rhs: Version) -> Bool {
        lhs.string.compare(rhs.string) == .orderedSame
    }

    public static func < (lhs: Version, rhs: Version) -> Bool {
        lhs.string.compare(rhs.string) == .orderedDescending
    }
    
    public static func > (lhs: Version, rhs: Version) -> Bool {
        lhs.string.compare(rhs.string) == .orderedAscending
    }
}
