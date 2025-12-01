import SwiftUI
//namth 2025 Popup dep

struct IntroPopupView: UIViewRepresentable {
    let message: String
    let title: String
    let imageName: String
    var onOkTapped: (() -> Void)?

    func makeUIView(context: Context) -> IntroPopupOpenAppNamth {
        let view = IntroPopupOpenAppNamth(message: message, title: title, tenanh: imageName)
        view.onOkTapped = onOkTapped
        return view
    }

    func updateUIView(_ uiView: IntroPopupOpenAppNamth, context: Context) {}
}




struct IntroPopupWrapperYESNO: UIViewControllerRepresentable {
    let message: String
    let title: String
    let imageName: String
    let onOk: () -> Void
    let onNo: () -> Void
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = UIColor.clear
        
        // 🧩 Thêm popup gốc của bạn vào controller
        let popup = IntroPopupOpenAppNamthYESNO(message: message, title: title, tenanh: imageName)
        popup.translatesAutoresizingMaskIntoConstraints = false
        
        popup.onOkTapped = {
            onOk()
        }
        
        popup.onNoTapped = {
            onNo()
        }

        controller.view.addSubview(popup)
        
        NSLayoutConstraint.activate([
            popup.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor),
            popup.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor),
            popup.topAnchor.constraint(equalTo: controller.view.topAnchor),
            popup.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor)
        ])
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}


struct IntroPopupWrapper: UIViewControllerRepresentable {
    let message: String
    let title: String
    let imageName: String
    let onOk: () -> Void
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = UIColor.clear
        
        // 🧩 Thêm popup gốc của bạn vào controller
        let popup = IntroPopupOpenAppNamth(message: message, title: title, tenanh: imageName)
        popup.translatesAutoresizingMaskIntoConstraints = false
        popup.onOkTapped = {
            onOk()
        }
        
        controller.view.addSubview(popup)
        
        NSLayoutConstraint.activate([
            popup.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor),
            popup.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor),
            popup.topAnchor.constraint(equalTo: controller.view.topAnchor),
            popup.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor)
        ])
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.system(size: 15))
            .foregroundColor(.white)
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(Color.black.opacity(0.8))
            .cornerRadius(12)
            .multilineTextAlignment(.center)
            .frame(maxWidth: 300)
            .transition(.opacity.combined(with: .scale))
            .zIndex(999)
    }
}

struct ToastModifier: ViewModifier {
    @Binding var isShowing: Bool
    let message: String
    let duration: TimeInterval

    func body(content: Content) -> some View {
        ZStack {
            content
            if isShowing {
                VStack {
                   // Spacer()
                    //ToastView(message: message)
                     //   .padding(.bottom, 80)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation {
                            isShowing = false
                        }
                    }
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isShowing)
    }
}

extension View {
    func toast(isShowing: Binding<Bool>, message: String, duration: TimeInterval = 1.0) -> some View {
        self.modifier(ToastModifier(isShowing: isShowing, message: message, duration: duration))
    }
}


class IntroPopupOpenAppNamth: UIView {
    var onOkTapped: (() -> Void)?
    private var gradientLayer: CAGradientLayer?
    private var shapeLayer: CAShapeLayer?
    private var container: UIView!
    
    private var scaleFactor: CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 1.5 : 1.0
    }

    init(message: String, title: String, tenanh: String) {
        super.init(frame: .zero)
        setupUI(message: message, title: title, tenanh: tenanh)
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(message: String, title: String, tenanh: String) {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)

        container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        container.layer.cornerRadius = 18 * scaleFactor
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.25
        container.layer.shadowRadius = 8 * scaleFactor
        addSubview(container)

        let logo = UIImageView(image: UIImage(named: tenanh))
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.contentMode = .scaleAspectFit

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20 * scaleFactor)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center

        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 16 * scaleFactor)
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .justified

        let okButton = UIButton(type: .system)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.setTitle("OK", for: .normal)
        okButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18 * scaleFactor)
        okButton.backgroundColor = UIColor.systemBlue
        okButton.setTitleColor(.white, for: .normal)
        okButton.layer.cornerRadius = 10 * scaleFactor
        okButton.addTarget(self, action: #selector(okTapped), for: .touchUpInside)

        container.addSubview(logo)
        container.addSubview(titleLabel)
        container.addSubview(messageLabel)
        container.addSubview(okButton)

        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: 350 * scaleFactor),

            logo.topAnchor.constraint(equalTo: container.topAnchor, constant: 20 * scaleFactor),
            logo.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            logo.heightAnchor.constraint(equalToConstant: 100 * scaleFactor),
            logo.widthAnchor.constraint(equalToConstant: 100 * scaleFactor),

            titleLabel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 10 * scaleFactor),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16 * scaleFactor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16 * scaleFactor),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8 * scaleFactor),
            messageLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16 * scaleFactor),
            messageLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16 * scaleFactor),

            okButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20 * scaleFactor),
            okButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20 * scaleFactor),
            okButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            okButton.widthAnchor.constraint(equalToConstant: 100 * scaleFactor),
            okButton.heightAnchor.constraint(equalToConstant: 40 * scaleFactor)
        ])
        
        // 👇 Thêm gesture nhận biết tap ra ngoài container
        let tapOutside = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        self.addGestureRecognizer(tapOutside)
    }

    @objc private func okTapped() {
        // Dừng animation khi đóng
        gradientLayer?.removeAllAnimations()
        gradientLayer?.removeFromSuperlayer()
        shapeLayer?.removeFromSuperlayer()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            self.removeFromSuperview()
            self.onOkTapped?()
        })
    }

    // 👇 Bấm ra ngoài vùng container → đóng popup
    @objc private func backgroundTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        if !container.frame.contains(location) {
           // self.alpha = 0
          //  self.removeFromSuperview()
          //  okTapped()
        }
    }

    // MARK: - ✨ Viền ánh sáng chạy DỌC lên xuống liên tục
    private func addShiningBorder() {
        gradientLayer?.removeFromSuperlayer()
        shapeLayer?.removeFromSuperlayer()
        
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.black.cgColor,
            UIColor.systemBlue.cgColor,
            UIColor.white.cgColor,
            UIColor.systemBlue.cgColor,
            UIColor.black.cgColor
        ]
        
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint   = CGPoint(x: 0.5, y: 1)
        gradient.frame = container.bounds
        gradient.cornerRadius = container.layer.cornerRadius
        gradient.masksToBounds = true

        let shape = CAShapeLayer()
        shape.lineWidth = 5 * scaleFactor
        shape.path = UIBezierPath(
            roundedRect: container.bounds.insetBy(dx: 2, dy: 2),
            cornerRadius: container.layer.cornerRadius
        ).cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.white.cgColor
        gradient.mask = shape
        container.layer.addSublayer(gradient)

        gradientLayer = gradient
        shapeLayer = shape

        // 🌈 Hiệu ứng ánh sáng chạy từ TRÊN → DƯỚI rồi ngược lại
        let move = CABasicAnimation(keyPath: "startPoint.y")
        move.fromValue = -1.0
        move.toValue   = 2.0
        move.duration = 1.3
        move.repeatCount = .infinity
        move.autoreverses = true
        move.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        gradient.add(move, forKey: "movingLight")

        // ✨ Nhấp nháy mềm
        let pulse = CABasicAnimation(keyPath: "opacity")
        pulse.fromValue = 1.0
        pulse.toValue   = 0.7
        pulse.duration  = 0.9
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        gradient.add(pulse, forKey: "pulse")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = container.bounds
        shapeLayer?.path = UIBezierPath(
            roundedRect: container.bounds.insetBy(dx: 2, dy: 2),
            cornerRadius: container.layer.cornerRadius
        ).cgPath
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.addShiningBorder()
                UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) {
                    self.alpha = 1
                    self.transform = .identity
                }
            }
        }
    }
}


class IntroPopupOpenAppNamthYESNO: UIView {
    var onOkTapped: (() -> Void)?
    var onNoTapped: (() -> Void)?
    
    private var gradientLayer: CAGradientLayer?
    private var shapeLayer: CAShapeLayer?
    private var container: UIView!
    
    private var scaleFactor: CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 1.5 : 1.0
    }

    init(message: String, title: String, tenanh: String) {
        super.init(frame: .zero)
        setupUI(message: message, title: title, tenanh: tenanh)
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(message: String, title: String, tenanh: String) {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)

        container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        container.layer.cornerRadius = 18 * scaleFactor
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.25
        container.layer.shadowRadius = 8 * scaleFactor
        addSubview(container)

        let logo = UIImageView(image: UIImage(named: tenanh))
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.contentMode = .scaleAspectFit

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20 * scaleFactor)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center

        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 16 * scaleFactor)
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .justified

        // ✅ Nút "No"
        let noButton = UIButton(type: .system)
        noButton.translatesAutoresizingMaskIntoConstraints = false
        noButton.setTitle("No", for: .normal)
        noButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18 * scaleFactor)
        noButton.backgroundColor = UIColor.systemGray
        noButton.setTitleColor(.white, for: .normal)
        noButton.layer.cornerRadius = 10 * scaleFactor
        noButton.addTarget(self, action: #selector(noTapped), for: .touchUpInside)

        // ✅ Nút "Yes" (trước là OK)
        let okButton = UIButton(type: .system)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.setTitle("Yes", for: .normal)
        okButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18 * scaleFactor)
        okButton.backgroundColor = UIColor.systemBlue
        okButton.setTitleColor(.white, for: .normal)
        okButton.layer.cornerRadius = 10 * scaleFactor
        okButton.addTarget(self, action: #selector(okTapped), for: .touchUpInside)

        container.addSubview(logo)
        container.addSubview(titleLabel)
        container.addSubview(messageLabel)
        container.addSubview(noButton)
        container.addSubview(okButton)

        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: 300 * scaleFactor),

            logo.topAnchor.constraint(equalTo: container.topAnchor, constant: 20 * scaleFactor),
            logo.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            logo.heightAnchor.constraint(equalToConstant: 100 * scaleFactor),
            logo.widthAnchor.constraint(equalToConstant: 100 * scaleFactor),

            titleLabel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 10 * scaleFactor),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16 * scaleFactor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16 * scaleFactor),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8 * scaleFactor),
            messageLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16 * scaleFactor),
            messageLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16 * scaleFactor),

            // ✅ Hai nút nằm ngang
            noButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20 * scaleFactor),
            noButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 30 * scaleFactor),
            noButton.widthAnchor.constraint(equalToConstant: 100 * scaleFactor),
            noButton.heightAnchor.constraint(equalToConstant: 40 * scaleFactor),
            noButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20 * scaleFactor),

            okButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20 * scaleFactor),
            okButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -30 * scaleFactor),
            okButton.widthAnchor.constraint(equalToConstant: 100 * scaleFactor),
            okButton.heightAnchor.constraint(equalToConstant: 40 * scaleFactor),
            okButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20 * scaleFactor)
        ])
        
        // 👇 Tap ra ngoài
        let tapOutside = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        self.addGestureRecognizer(tapOutside)
    }

    // ✅ Hành động nút Yes
    @objc private func okTapped() {
        gradientLayer?.removeAllAnimations()
        gradientLayer?.removeFromSuperlayer()
        shapeLayer?.removeFromSuperlayer()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            self.removeFromSuperview()
            self.onOkTapped?()
        })
    }

    // ✅ Hành động nút No
    @objc private func noTapped() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            self.removeFromSuperview()
            self.onNoTapped?()
        })
    }

    @objc private func backgroundTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        if !container.frame.contains(location) {
            // Không tự động đóng khi bấm ra ngoài
        }
    }

    // MARK: - ✨ Viền ánh sáng
    private func addShiningBorder() {
        gradientLayer?.removeFromSuperlayer()
        shapeLayer?.removeFromSuperlayer()
        
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.black.cgColor,
            UIColor.systemBlue.cgColor,
            UIColor.white.cgColor,
            UIColor.systemBlue.cgColor,
            UIColor.black.cgColor
        ]
        
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint   = CGPoint(x: 0.5, y: 1)
        gradient.frame = container.bounds
        gradient.cornerRadius = container.layer.cornerRadius
        gradient.masksToBounds = true

        let shape = CAShapeLayer()
        shape.lineWidth = 5 * scaleFactor
        shape.path = UIBezierPath(
            roundedRect: container.bounds.insetBy(dx: 2, dy: 2),
            cornerRadius: container.layer.cornerRadius
        ).cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.white.cgColor
        gradient.mask = shape
        container.layer.addSublayer(gradient)

        gradientLayer = gradient
        shapeLayer = shape

        let move = CABasicAnimation(keyPath: "startPoint.y")
        move.fromValue = -1.0
        move.toValue   = 2.0
        move.duration = 1.3
        move.repeatCount = .infinity
        move.autoreverses = true
        move.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        gradient.add(move, forKey: "movingLight")

        let pulse = CABasicAnimation(keyPath: "opacity")
        pulse.fromValue = 1.0
        pulse.toValue   = 0.7
        pulse.duration  = 0.9
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        gradient.add(pulse, forKey: "pulse")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = container.bounds
        shapeLayer?.path = UIBezierPath(
            roundedRect: container.bounds.insetBy(dx: 2, dy: 2),
            cornerRadius: container.layer.cornerRadius
        ).cgPath
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.addShiningBorder()
                UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) {
                    self.alpha = 1
                    self.transform = .identity
                }
            }
        }
    }
}


