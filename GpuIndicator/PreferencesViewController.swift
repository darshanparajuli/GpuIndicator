import Cocoa

class PreferencesViewController: NSViewController {
    @IBOutlet weak var integratedGpuColorWell: NSColorWell!
    @IBOutlet weak var discreteGpuColorWell: NSColorWell!
    @IBOutlet weak var removableGpuColorWell: NSColorWell!
    
    private var appDelegate: AppDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = NSApplication.shared.delegate as? AppDelegate
        
        integratedGpuColorWell.color = Preferences.getColor(gpuType: .Integrated)
        discreteGpuColorWell.color = Preferences.getColor(gpuType: .Discrete)
        removableGpuColorWell.color = Preferences.getColor(gpuType: .Removable)
    }
    
    @IBAction func onActionChangeColorIntegratedGpu(_ sender: NSColorWell) {
        appDelegate?.onGpuIndicatorColorChange(gpuType: .Integrated, color: sender.color)
    }

    @IBAction func onActionChangeColorDiscreteGpu(_ sender: NSColorWell) {
        appDelegate?.onGpuIndicatorColorChange(gpuType: .Discrete, color: sender.color)
    }
    
    @IBAction func onActionChangeColorRemovableGpu(_ sender: NSColorWell) {
        appDelegate?.onGpuIndicatorColorChange(gpuType: .Removable, color: sender.color)
    }
}
