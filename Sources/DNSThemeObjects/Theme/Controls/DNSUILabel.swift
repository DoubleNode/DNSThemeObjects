//
//  DNSUILabel.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSThemeObjects
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//
//  Derived from work done by Paulo Silva
//  https://github.com/paulosilva/CustomUIView
//

import DNSThemeTypes
import UIKit

@IBDesignable open class DNSUILabel: UILabel {
    public typealias ThemeStyle = DNSThemeLabelStyle
    private var _settingStyleInProgress = false
    public var style: DNSThemeStyle = ThemeStyle.default {
        didSet {
//            guard oldValue != style else { return }
            _settingStyleInProgress = true
            self.styleName = style.fullName
            _settingStyleInProgress = false
            self.utilityApply(style)
        }
    }
    @IBInspectable open var styleName: String = ThemeStyle.default.fullName {
        didSet {
            guard oldValue != styleName else { return }
            guard !_settingStyleInProgress else { return }
            self.utilityApply(styleName)
        }
    }

    // MARK: - Utility Methods -
    open func utilityApply(_ styleName: String) {
        self.style = ThemeStyle.themeStyle(named: styleName)
    }
    open func utilityApply(_ style: DNSThemeStyle) {
        self.backgroundColor = style.backgroundColor.normal
        self.borderColor = style.border.color.normal
        self.borderWidth = CGFloat(style.border.width)
        self.cornerRadius = CGFloat(style.border.cornerRadius)
        self.cornerTopLeftRadius = CGFloat(style.border.cornerTopLeftRadius)
        self.cornerTopRightRadius = CGFloat(style.border.cornerTopRightRadius)
        self.cornerBottomLeftRadius = CGFloat(style.border.cornerBottomLeftRadius)
        self.cornerBottomRightRadius = CGFloat(style.border.cornerBottomRightRadius)
        self.cornerRadiusMulti = style.border.cornerRadiusMulti
        self.shadowColor = style.shadow.color.normal
        self.shadowOffset = style.shadow.offset
        self.shadowOpacity = Float(style.shadow.opacity)
        self.shadowRadius = style.shadow.radius
        self.tintColor = style.tintColor.normal
        
        if let style = style as? DNSThemeLabelStyle {
            self.font = style.font.normal
            self.paragraphStyle = style.paragraphStyle
            self.strikeThru = style.strikeThru.enabled.normal
            self.strikeThruColor = style.strikeThru.color.normal
            self.strikeThruStyle = style.strikeThru.style
            self.textColor = style.color.normal
            if style.zeplinLineHeight != nil {
                self.zeplinLineHeight = style.zeplinLineHeight!
            }
        }
    }
    open func utilityRedrawAttributeString() {
        guard let text = self.text, !text.isEmpty else {
            self.attributedText = nil
            return
        }
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                     value: self.paragraphStyle,
                                     range: NSMakeRange(0, attributeString.length))
        if self.strikeThru {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                         value: self.strikeThruStyle.rawValue,
                                         range: NSMakeRange(0, attributeString.length))
            attributeString.addAttribute(NSAttributedString.Key.strikethroughColor,
                                         value: self.strikeThruColor,
                                         range: NSMakeRange(0, attributeString.length))
        }
        self.attributedText = attributeString
    }
    
    public override var isEnabled: Bool {
        didSet {
            guard let style = style as? ThemeStyle else {
                self.updateForState(using: style)
                return
            }
            self.updateForState(using: style)
        }
    }
    public override var isHighlighted: Bool {
        didSet {
            guard let style = style as? ThemeStyle else {
                self.updateForState(using: style)
                return
            }
            self.updateForState(using: style)
        }
    }
    public var isSelected: Bool = false {
        didSet {
            guard let style = style as? ThemeStyle else {
                self.updateForState(using: style)
                return
            }
            self.updateForState(using: style)
        }
    }
    
    // MARK: - Private Variables -
    private let containerView = UIView()
    private var containerImageView = UIImageView()
    private var paragraphStyle = NSMutableParagraphStyle()
    // MARK: - Public Attributes -
    override open var text: String? {
        didSet {
            //            self.attributedText = nil
            self.utilityRedrawAttributeString()
        }
    }
    @IBInspectable public var zeplinLineHeight: CGFloat {
        get {
            let fontOffset = self.font.lineHeight - self.font.pointSize
            return self.paragraphStyle.lineSpacing + self.font.pointSize + fontOffset
        }
        set {
            let fontOffset = self.font.lineHeight - self.font.pointSize
            self.paragraphStyle.lineSpacing = newValue - self.font.pointSize - fontOffset
            self.utilityRedrawAttributeString()
        }
    }
    // MARK: - Public Attributes (UIView) -
//    @IBInspectable public var backgroundImage: UIImage? {
//        get {
//            return self.containerImageView.image
//        }
//        set {
////            addShadowColorFromBackgroundImage()
//            self.containerImageView.image = newValue
//        }
//    }
    override open var backgroundColor: UIColor? {
        didSet {
            guard backgroundColor != nil else { return }
            containerView.backgroundColor = nil
//            containerView.backgroundColor = backgroundColor
//            if backgroundColor != UIColor.clear {
//                backgroundColor = nil
//            }
        }
    }
    override open var clipsToBounds: Bool {
        didSet {
            let newClip = clipsToBounds
            containerView.clipsToBounds = newClip
            containerImageView.clipsToBounds = newClip
        }
    }
    @IBInspectable open var borderColor: UIColor {
        get {
            return UIColor(cgColor: self.containerView.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.cgColor
            self.containerView.layer.borderColor = newValue.cgColor
        }
    }
    @IBInspectable open var borderWidth: CGFloat {
        get {
            return self.containerView.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
            self.containerView.layer.borderWidth = newValue
        }
    }
    @IBInspectable open var cornerRadius: CGFloat {
        get {
            return self.containerView.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.containerView.layer.cornerRadius = newValue
        }
    }
    @IBInspectable open var cornerRadiusMulti: Bool = false
    @IBInspectable open var cornerTopLeftRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
    @IBInspectable open var cornerTopRightRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
    @IBInspectable open var cornerBottomLeftRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
    @IBInspectable open var cornerBottomRightRadius: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
    @IBInspectable open var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
            self.containerView.layer.shadowOpacity = newValue
        }
    }
    @IBInspectable open var shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
            self.containerView.layer.shadowRadius = newValue
        }
    }
    @IBInspectable override open var shadowOffset: CGSize {
        didSet {
            self.containerView.layer.shadowOffset = shadowOffset
        }
    }
    @IBInspectable override open var shadowColor: UIColor? {
        didSet {
            guard let shadowColor = shadowColor else { return }
            self.containerView.layer.shadowColor = shadowColor.cgColor
        }
    }
    //    @IBInspectable var shadowColorFromImage: Bool = false {
    //        didSet {
    //            addShadowColorFromBackgroundImage()
    //        }
    //    }
    @IBInspectable open var strikeThru: Bool = false {
        didSet {
            self.utilityRedrawAttributeString()
        }
    }
    @IBInspectable open var strikeThruColor: UIColor = UIColor.red {
        didSet {
            self.utilityRedrawAttributeString()
        }
    }
    @IBInspectable open var strikeThruStyle: NSUnderlineStyle = NSUnderlineStyle.thick {
        didSet {
            self.utilityRedrawAttributeString()
        }
    }
    
    override open func prepareForInterfaceBuilder() {
        setupView()
        refreshViewLayout()
    }
    func setupView() {
        self.backgroundColor = self.containerView.backgroundColor
        self.clipsToBounds = self.clipsToBounds
        self.borderColor = self.borderColor
        self.borderWidth = self.borderWidth
        self.cornerRadius = self.cornerRadius
        self.shadowOpacity = self.shadowOpacity
        self.shadowRadius = self.shadowRadius
        self.shadowOffset = self.shadowOffset
        self.shadowColor = self.shadowColor
        applyRadiusMaskFor()
    }
    
    // MARK: - Life Cycle -
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        utilityApply(style)
        addViewLayoutSubViews()
        refreshViewLayout()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        utilityApply(style)
        addViewLayoutSubViews()
        refreshViewLayout()
    }
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        refreshViewLayout()
//        addShadowColorFromBackgroundImage()
        self.utilityRedrawAttributeString()
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        refreshViewLayout()
//        addShadowColorFromBackgroundImage()
        applyRadiusMaskFor()
        self.utilityRedrawAttributeString()
    }
    
    public func refreshViewLayout() {
        // View
        self.layer.masksToBounds = self.clipsToBounds
        self.layer.cornerRadius = cornerRadius
        
        // Container View
        self.sendSubviewToBack(self.containerView)
        self.containerView.clipsToBounds = self.clipsToBounds
        self.containerView.layer.masksToBounds = self.layer.masksToBounds
        self.containerView.layer.cornerRadius = cornerRadius
        
        // Image View
        self.containerImageView.backgroundColor = UIColor.clear
        //self.containerImageView.image = backgroundImage
        self.containerImageView.layer.cornerRadius = cornerRadius
        self.containerImageView.layer.masksToBounds = self.layer.masksToBounds
        self.containerImageView.clipsToBounds = self.clipsToBounds
        self.containerImageView.contentMode = .redraw
        self.containerImageView.isUserInteractionEnabled = false
    }
    // MARK: - Private Methods -
    private func addViewLayoutSubViews() {
        // add subViews
        self.containerView.backgroundColor = UIColor.clear
        self.insertSubview(self.containerView, at: 0)
        self.sendSubviewToBack(self.containerView)
        self.containerView.addSubview(self.containerImageView)
        self.backgroundColor = UIColor.systemBackground

        self.containerView.isUserInteractionEnabled = false
        self.containerImageView.isUserInteractionEnabled = false
        
        // add image constraints
        self.containerImageView.translatesAutoresizingMaskIntoConstraints = false
        self.containerImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        self.containerImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        self.containerImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        self.containerImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        // add view constraints
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        self.containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        self.containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        self.containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
//    private func addShadowColorFromBackgroundImage() {
//        // Get the averageColor from the image for set the Shadow Color
//        if shadowColorFormImage {
//            let week = self
//            DispatchQueue.main.async {
//                week.shadowColor = (week.containerImageView.image?.averageColor)!
//            }
//        }
//    }
    private func applyRadiusMaskFor() {
        guard cornerRadiusMulti else { return }
        
        let path = UIBezierPath(shouldRoundRect: bounds,
                                topLeftRadius: cornerTopLeftRadius,
                                topRightRadius: cornerTopRightRadius,
                                bottomLeftRadius: cornerBottomLeftRadius,
                                bottomRightRadius: cornerBottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        layer.mask = shape
    }
    
    func updateForState(using style: DNSThemeStyle) {
        if self.isEnabled {
            // DNSThemeStyle
            self.backgroundColor = style.backgroundColor.normal
            self.layer.borderColor = style.border.color.normal.cgColor
            self.layer.shadowColor = style.shadow.color.normal.cgColor
            self.isSkeletonable = style.skeletonable.normal
            self.tintColor = style.tintColor.normal
        } else {
            // DNSThemeStyle
            self.backgroundColor = style.backgroundColor.disabled
            self.layer.borderColor = style.border.color.disabled.cgColor
            self.layer.shadowColor = style.shadow.color.disabled.cgColor
            self.isSkeletonable = style.skeletonable.disabled
            self.tintColor = style.tintColor.disabled
        }
        if self.isSelected {
            // DNSThemeStyle
            self.backgroundColor = style.backgroundColor.selected
            self.layer.borderColor = style.border.color.selected.cgColor
            self.layer.shadowColor = style.shadow.color.selected.cgColor
            self.isSkeletonable = style.skeletonable.selected
            self.tintColor = style.tintColor.selected
        }
        if self.isHighlighted {
            // DNSThemeStyle
            self.backgroundColor = style.backgroundColor.highlighted
            self.layer.borderColor = style.border.color.highlighted.cgColor
            self.layer.shadowColor = style.shadow.color.highlighted.cgColor
            self.isSkeletonable = style.skeletonable.highlighted
            self.tintColor = style.tintColor.highlighted
        }
        if self.isFocused {
            // DNSThemeStyle
            self.backgroundColor = style.backgroundColor.focused
            self.layer.borderColor = style.border.color.focused.cgColor
            self.layer.shadowColor = style.shadow.color.focused.cgColor
            self.isSkeletonable = style.skeletonable.focused
            self.tintColor = style.tintColor.focused
        }
    }
    public func updateForState(using style: ThemeStyle) {
        self.updateForState(using: style as DNSThemeStyle)
        if self.isEnabled {
            // DNSThemeLabelStyle
            self.font = style.font.normal
            self.shadowColor = style.shadow.color.normal
            self.textColor = style.color.normal
        } else {
            // DNSThemeLabelStyle
            self.font = style.font.disabled
            self.shadowColor = style.shadow.color.disabled
            self.textColor = style.color.disabled
        }
        if self.isSelected {
            // DNSThemeLabelStyle
            self.font = style.font.selected
            self.shadowColor = style.shadow.color.selected
            self.textColor = style.color.selected
        }
        if self.isHighlighted {
            // DNSThemeLabelStyle
            self.font = style.font.highlighted
            self.shadowColor = style.shadow.color.highlighted
            self.textColor = style.color.highlighted
        }
        if self.isFocused {
            // DNSThemeLabelStyle
            self.font = style.font.focused
            self.shadowColor = style.shadow.color.focused
            self.textColor = style.color.focused
        }
    }
}
