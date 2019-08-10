import Cocoa

class PreferencesViewController: NSViewController {
    @IBOutlet weak var integratedGpuColorWell: NSColorWell!
    @IBOutlet weak var discreteGpuColorWell: NSColorWell!
    @IBOutlet weak var removableGpuColorWell: NSColorWell!
    
    private var appDelegate: AppDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = NSApplication.shared.delegate as? AppDelegate
        
        updateGpuColorWell(gpuType: .Integrated)
        updateGpuColorWell(gpuType: .Discrete)
        updateGpuColorWell(gpuType: .Removable)
    }
    
    private func updateGpuColorWell(gpuType: GpuType) {
        switch (gpuType) {
        case .Integrated:
            integratedGpuColorWell.color = Preferences.getColor(gpuType: .Integrated)
        case .Discrete:
            discreteGpuColorWell.color = Preferences.getColor(gpuType: .Discrete)
        case .Removable:
            removableGpuColorWell.color = Preferences.getColor(gpuType: .Removable)
        }
    }
    
    @IBAction func onActionChangeColorIntegratedGpu(_ sender: NSColorWell) {
        appDelegate?.updateGpuIndicatorColor(gpuType: .Integrated, color: sender.color)
    }

    @IBAction func onActionChangeColorDiscreteGpu(_ sender: NSColorWell) {
        appDelegate?.updateGpuIndicatorColor(gpuType: .Discrete, color: sender.color)
    }
    
    @IBAction func onActionChangeColorRemovableGpu(_ sender: NSColorWell) {
        appDelegate?.updateGpuIndicatorColor(gpuType: .Removable, color: sender.color)
    }
    
    @IBAction func onActionResetIntegratedGpuColor(_ sender: NSButton) {
        appDelegate?.updateGpuIndicatorColor(gpuType: .Integrated, color: Preferences.defaultIntegratedGpuColor, save: false)
        Preferences.clearColor(gpuType: .Integrated)
        updateGpuColorWell(gpuType: .Integrated)
    }
    
    @IBAction func onActionResetDiscreteGpuColor(_ sender: NSButton) {
        appDelegate?.updateGpuIndicatorColor(gpuType: .Discrete, color: Preferences.defaultDiscreteGpuColor, save: false)
        Preferences.clearColor(gpuType: .Discrete)
        updateGpuColorWell(gpuType: .Discrete)
    }
    
    @IBAction func onActionResetRemovableGpuColor(_ sender: NSButton) {
        appDelegate?.updateGpuIndicatorColor(gpuType: .Removable, color: Preferences.defaultRemovableGpuColor, save: false)
        Preferences.clearColor(gpuType: .Removable)
        updateGpuColorWell(gpuType: .Removable)
    }
}
