import Cocoa

enum GpuType {
    case Integrated
    case Discrete
    case Removable
}

class Preferences {
    
    private static let keyIntegratedGpuColor = "keyPrefIntegratedGpuColor"
    private static let keyDedicatedGpuColor = "keyPrefDedicatedGpuColor"
    private static let keyRemovableGpuColor = "keyPrefRemovableGpuColor"

    private init() {}

    public static func getColor(gpuType: GpuType) -> NSColor {
        switch (gpuType) {
        case .Integrated:
            return getColor(key: keyIntegratedGpuColor) ?? NSColor.controlColor
            
        case .Discrete:
            return getColor(key: keyDedicatedGpuColor) ?? NSColor.systemBlue
            
        case .Removable:
            return getColor(key: keyRemovableGpuColor) ?? NSColor.systemGreen
        }
    }

    public static func setColor(gpuType: GpuType, color: NSColor) {
        switch (gpuType) {
        case .Integrated:
            setColor(key: keyIntegratedGpuColor, value: color)
        case .Discrete:
            setColor(key: keyDedicatedGpuColor, value: color)
        case .Removable:
            setColor(key: keyRemovableGpuColor, value: color)
        }
    }
    
    private static func setColor(key: String, value: NSColor) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(value.toColor()), forKey: key)
    }
    
    private static func getColor(key: String) -> NSColor? {
        if let data = UserDefaults.standard.object(forKey: key) as? Data {
            if let color = try? PropertyListDecoder().decode(Color.self, from: data) {
                return NSColor.fromColor(color: color)
            }
        }
        
        return nil
    }
}

extension NSColor {
    class func fromColor(color: Color) -> NSColor {
        return NSColor(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: CGFloat(1.0))
    }

    func toColor() -> Color {
        return Color(Float(self.redComponent), Float(self.greenComponent), Float(self.blueComponent))
    }
}

struct Color : Codable {
    var red: Float = 0.0
    var green: Float = 0.0
    var blue: Float = 0.0

    init(_ red: Float, _ green: Float, _ blue: Float) {
        self.red = red
        self.green = green
        self.blue = blue
    }
}
