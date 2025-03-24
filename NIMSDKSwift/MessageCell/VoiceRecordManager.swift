import AVFoundation

class VoiceRecordManager {
    // 状态回调闭包
    var onRecordingStart: (() -> Void)?
    var onRecordingFinish: ((URL?) -> Void)?
    var onTimeUpdate: ((String) -> Void)?
    
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    private var parentVC: UIViewController?
    private var recordingView: UIView!
    private var timeLabel: UILabel!
    
    init(parentVC: UIViewController) {
        self.parentVC = parentVC
        setupRecordingView()
    }
    
    // MARK: - 视图配置
    private func setupRecordingView() {
        recordingView = UIView(frame: CGRect(x: 0, y: 0, width: 160, height: 160))
        recordingView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        recordingView.layer.cornerRadius = 12
        recordingView.alpha = 0
        
        timeLabel = UILabel()
        timeLabel.text = "00:00"
        timeLabel.textColor = .white
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 32, weight: .bold)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        recordingView.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: recordingView.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: recordingView.centerYAnchor)
        ])
    }
    
    // MARK: - 公共方法
    func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            startRecording()
        case .ended:
            finishRecording()
        case .cancelled, .failed:
            cancelRecording()
        default: break
        }
    }
    
    // MARK: - 录音控制
    private func startRecording() {
        setupAudioSession()
        createAudioRecorder()
        
        audioRecorder?.record()
        startTimer()
        showRecordingView()
        onRecordingStart?()
    }
    
    private func finishRecording() {
        audioRecorder?.stop()
        let url = audioRecorder?.url
        cleanup()
        onRecordingFinish?(url)
    }
    
    private func cancelRecording() {
        audioRecorder?.stop()
        if let url = audioRecorder?.url {
            try? FileManager.default.removeItem(at: url)
        }
        cleanup()
        onRecordingFinish?(nil)
    }
    
    // MARK: - 辅助方法
    private func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playAndRecord, mode: .default)
        try? session.setActive(true)
    }
    
    private func createAudioRecorder() {
        let filename = "\(UUID().uuidString).m4a"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        audioRecorder = try? AVAudioRecorder(url: fileURL, settings: settings)
    }
    
    private func startTimer() {
        var seconds = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            seconds += 1
            let timeString = String(format: "%02d:%02d", seconds / 60, seconds % 60)
            self?.timeLabel.text = timeString
            self?.onTimeUpdate?(timeString)
        }
    }
    
    private func showRecordingView() {
        guard let parent = parentVC else { return }
        
        parent.view.addSubview(recordingView)
        recordingView.center = CGPoint(x: parent.view.center.x, y: parent.view.center.y - 100)
        
        UIView.animate(withDuration: 0.3) {
            self.recordingView.alpha = 1
        }
    }
    
    private func cleanup() {
        timer?.invalidate()
        audioRecorder = nil
        
        UIView.animate(withDuration: 0.3) {
            self.recordingView.alpha = 0
        }
    }
}