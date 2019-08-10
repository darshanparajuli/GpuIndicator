import Cocoa

enum GpuType {
    case Integrated
    case Discrete
    case Removable
}

class Preferences {
    
    public static let defaultIntegratedGpuColor = NSColor.controlColor
    public static let defaultDiscreteGpuColor = NSColor.systemBlue
    public static let defaultRemovableGpuColor = NSColor.systemGreen
    
    private static let keyIntegratedGpuColor = "keyPrefIntegratedGpuColor"
    private static let keyDiscreteGpuColor = "keyPrefDiscreteGpuColor"
    private static let keyRemovableGpuColor = "keyPrefRemovableGpuColor"

    private init() {}

    public static func getColor(gpuType: GpuType) -> NSColor {
        switch (gpuType) {
        case .Integrated:
            return getColor(key: keyIntegratedGpuColor) ?? defaultIntegratedGpuColor
            
        case .Discrete:
            return getColor(key: keyDiscreteGpuColor) ?? defaultDiscreteGpuColor
            
        case .Removable:
            return getColor(key: keyRemovableGpuColor) ?? defaultRemovableGpuColor
        }
    }

    public static func setColor(gpuType: GpuType, color: NSColor) {
        switch (gpuType) {
        case .Integrated:
            setColor(key: keyIntegratedGpuColor, value: color)
        case .Discrete:
            setColor(key: keyDiscreteGpuColor, value: color)
        case .Removable:
            setColor(key: keyRemovableGpuColor, value: color)
        }
    }
    
    public static func clearColor(gpuType: GpuType) {
        switch (gpuType) {
        case .Integrated:
            UserDefaults.standard.removeObject(forKey: keyIntegratedGpuColor)
        case .Discrete:
            UserDefaults.standard.removeObject(forKey: keyDiscreteGpuColor)
        case .Removable:
            UserDefaults.standard.removeObject(forKey: keyRemovableGpuColor)
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
