//
//  BRTextField.swift
//  BRTextField
//
//  Created by Archy on 2017/12/14.
//  Copyright © 2017年 Archy. All rights reserved.
//

import UIKit

enum BRTextFieldStyle {
    case normal
    case close
    case password
    case verify
    case international
    
    var selector: Selector {
        switch self {
        case .normal: return #selector(BRTextField.configNormalStyle)
        case .close: return #selector(BRTextField.configCloseStyle)
        case .password: return #selector(BRTextField.configPasswordStyle)
        case .verify: return #selector(BRTextField.configVerifyCodeStyle)
        case .international: return #selector(BRTextField.configInternationalStyle)
        }
    }
}

@objc protocol BRTextFieldDelegate {
    @objc optional func textFieldDidClickSupplyView(_ textField: BRTextField)
}

@IBDesignable
public class BRTextField: UITextField {

    var brDelegate: BRTextFieldDelegate?
    var style: BRTextFieldStyle = .normal {
        didSet {
            self.updateStyle()
        }
    }
    @IBInspectable public var isNeedUnderLine: Bool = true {
        didSet {
            self.underlineView.isHidden = !self.isNeedUnderLine
        }
    }
    @IBInspectable public var isNeedAnimation: Bool = true
    @IBInspectable public var isNeedFloating: Bool = true {
        didSet {
            self.lblFloat.isHidden = !self.isNeedFloating
        }
    }
    @IBInspectable public var underlineColor: UIColor = UIColor.black {
        didSet {
            self.underlineView.backgroundColor = self.underlineColor
        }
    }
    override public var placeholder: String? {
        didSet {
            if self.floatText == nil {
                self.floatText = placeholder
                self.lblFloat.text = placeholder
            }
        }
    }
    override public var textAlignment: NSTextAlignment {
        didSet {
            self.lblFloat.textAlignment = textAlignment
        }
    }
    override public var font: UIFont? {
        didSet {
            self.lblFloat.font = UIFont.systemFont(ofSize: (font?.pointSize)! - 2)
        }
    }
    @IBInspectable public var floatText: String? {
        didSet {
            self.lblFloat.text = floatText
        }
    }
    
    @IBInspectable public var floatColor: UIColor = UIColor.init(red: 0, green: 0, blue: 0.1, alpha: 0.22) {
        didSet {
            self.lblFloat.textColor = floatColor
        }
    }
    var floatFont: UIFont? = UIFont.systemFont(ofSize: 15) {
        didSet {
            self.lblFloat.font = floatFont
        }
    }
    @IBInspectable public var supplyColor: UIColor? {
        didSet {
            self.lblSupply.textColor = supplyColor
        }
    }
    @IBInspectable public var supplyText: String? {
        didSet {
            self.lblSupply.text = supplyText
        }
    }
    @IBInspectable public var isSupplyEnabled: Bool = true {
        didSet {
            self.tapSupply.isEnabled = isSupplyEnabled
        }
    }
    
    // MARK: File Private
    fileprivate lazy var lblFloat: UILabel = {
        let lbl = UILabel.init()
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.alpha = 0
        return lbl
    }()
    
    fileprivate lazy var underlineView: UIView = {
        let view = UIView.init()
        view.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8980392157, blue: 0.9098039216, alpha: 1)
        return view
    }()
    
    fileprivate lazy var btnClose: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "close_clicked", in: self.resource, compatibleWith: nil), for: .normal)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(resetTextField), for: .touchUpInside)
        return btn
    }()
    
    fileprivate lazy var btnSecureEye: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "eye_reg", in: self.resource, compatibleWith: nil), for: .normal)
        btn.setImage(UIImage.init(named: "eye_clicked", in: self.resource, compatibleWith: nil), for: .selected)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(changeTextFieldSecure), for: .touchUpInside)
        btn.isSelected = !self.isSecureTextEntry
        return btn
    }()
    
    fileprivate lazy var verticalSepLine: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 15))
        view.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8980392157, blue: 0.9098039216, alpha: 1)
        return view
    }()
    
    fileprivate lazy var imgMore: UIImageView = {
        let img = UIImageView.init(image: UIImage.init(named: "icon_arrows_down_b_xs", in: self.resource, compatibleWith: nil))
        return img
    }()
    fileprivate lazy var lblSupply: UILabel = {
        let lbl = UILabel.init()
        lbl.textAlignment = .center
        return lbl
    }()
    fileprivate var viewInternational: UIView?
    fileprivate var viewVerify: UIView?
    fileprivate var viewPassword: UIView?
    fileprivate lazy var tapSupply: UIGestureRecognizer = {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(supplyAction))
        return tap
    }()
    fileprivate lazy var resource : Bundle = {
        let bundle = Bundle(for: self.classForCoder)
        let url = bundle.resourceURL?.appendingPathComponent("BRTextField.bundle")
        let brBundle = Bundle(url: url!)!
        return brBundle
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        propertyInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.propertyInit()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.updateUI()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.updateFrame()
    }
    
    fileprivate func propertyInit() {
        self.borderStyle = .none
        self.clipsToBounds = false
        self.backgroundColor = .clear
        self.textColor = .black
        self.font = UIFont.systemFont(ofSize: 17)
    }
    
    fileprivate func updateUI() {
        if self.floatText == nil {
            self.lblFloat.text = self.placeholder
        } else {
            self.lblFloat.text = self.floatText
        }
        self.lblFloat.textColor = self.floatColor
        self.addSubview(self.lblFloat)
        self.addSubview(self.underlineView)
        
        self.updateFrame()
        self.addObserverOrAction()
    }
    
    override public func prepareForInterfaceBuilder() {
        self.lblFloat.frame = self.floatLabelRect(rect: self.textRect(forBounds: self.bounds), editing: false)
        self.underlineView.frame = CGRect(x: 0, y: self.bounds.size.height - 0.5, width: self.bounds.size.width, height: 0.5)
    }
    
    fileprivate func updateFrame() {
        self.lblFloat.frame = self.floatLabelRect(rect: self.textRect(forBounds: self.bounds), editing: self.text!.count > 0)
        self.underlineView.frame = CGRect(x: 0, y: self.bounds.size.height - 0.5, width: self.bounds.size.width, height: 0.5)
    }
    
    fileprivate func addObserverOrAction() {
        self.addTarget(self, action: #selector(inputDidBegin), for: .editingDidBegin)
        self.addTarget(self, action: #selector(inputDidChange), for: .editingChanged)
        self.addTarget(self, action: #selector(inputDidEnd), for: .editingDidEnd)
    }
    
    fileprivate func floatLabelRect(rect: CGRect,editing: Bool) -> CGRect {
        if editing {
            return CGRect(x: rect.origin.x , y: -self.lblFloat.font.lineHeight, width: rect.size.width, height: self.lblFloat.font.lineHeight)
        }
        return CGRect(x: rect.origin.x, y: 0, width: rect.size.width, height: rect.size.height)
    }
    
    fileprivate func floatShow() {
        if isNeedAnimation {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.lblFloat.alpha = 1
                self.lblFloat.frame = self.floatLabelRect(rect: self.textRect(forBounds: self.bounds), editing: true)
            }, completion: nil)
        } else {
            lblFloat.alpha = 1
            lblFloat.frame = floatLabelRect(rect: self.textRect(forBounds: self.bounds), editing: true)
        }
    }
    
    fileprivate func floatHide() {
        if isNeedAnimation {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.lblFloat.alpha = 0
                self.lblFloat.frame = self.floatLabelRect(rect: self.textRect(forBounds: self.bounds), editing: false)
            }, completion: nil)
        } else {
            lblFloat.alpha = 0
            lblFloat.frame = floatLabelRect(rect: self.textRect(forBounds: self.bounds), editing: false)
        }
    }
    
    fileprivate func floatIsShow() -> Bool {
        let show = self.floatLabelRect(rect: self.textRect(forBounds: self.bounds), editing: true)
        return self.lblFloat.frame.equalTo(show)
    }
    
    @objc fileprivate func inputDidChange(textField: BRTextField) {
        if isNeedFloating == false {
            return
        }
        
        if text!.count > 0 {
            if !floatIsShow() {
                floatShow()
            }
        } else {
            if floatIsShow() {
                floatHide()
            }
        }
    }
    
    @objc fileprivate func inputDidBegin(textField: BRTextField) {
        reactionForStyleWhenBegin()
    }
    
    @objc fileprivate func inputDidEnd(textField: BRTextField) {
        reactionForStyleWhenEnd()
    }
    
    fileprivate func reactionForStyleWhenBegin() {
        if self.style != .close && self.style != .international {
            self.btnClose.isHidden = false
            self.verticalSepLine.isHidden = false
        }
    }
    
    fileprivate func reactionForStyleWhenEnd() {
        if self.style != .close && self.style != .international {
            self.btnClose.isHidden = true
            self.verticalSepLine.isHidden = true
        }
    }

    @objc fileprivate func resetTextField(_ sender: UIButton) {
        self.text = nil
        floatHide()
    }
    
    @objc fileprivate func changeTextFieldSecure(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.isSecureTextEntry = !sender.isSelected
    }
    
    @objc fileprivate func supplyAction(_ sender: UITapGestureRecognizer) {
        if let dele = self.brDelegate {
            dele.textFieldDidClickSupplyView!(self)
        }
    }
    
    fileprivate func updateSupplyView() {
        if self.style == .international {
            self.updateStyle()
        } else if self.style == .verify {
            self.lblSupply.text = self.supplyText
        }
    }
    
    fileprivate func updateStyle() {
        self.resetModules()
        
        self.perform(self.style.selector)
    }
    
    fileprivate func resetModules() {
        self.btnClose.removeFromSuperview()
        self.btnSecureEye.removeFromSuperview()
        self.verticalSepLine.removeFromSuperview()
        
        self.leftView = nil
        self.rightView = nil
        self.leftView?.removeGestureRecognizer(self.tapSupply)
        self.rightView?.removeGestureRecognizer(self.tapSupply)
    }
    
    @objc fileprivate func configNormalStyle() {}
    
    @objc fileprivate func configCloseStyle() {
        self.rightView = self.btnClose
        self.rightViewMode = .whileEditing
    }
    
    @objc fileprivate func configPasswordStyle() {
        let totalWidth = btnClose.bounds.size.width + btnSecureEye.bounds.size.width + verticalSepLine.bounds.size.width + 10 * 2
        self.viewPassword = UIView(frame: CGRect.init(x: 0, y: 0, width: totalWidth, height: self.bounds.size.height))
        
        let closeX: CGFloat = 0
        let closeY: CGFloat = (self.bounds.size.height-self.btnClose.bounds.size.height)/2.0
        let closeWidth: CGFloat = self.btnClose.bounds.size.width
        let closeHeight: CGFloat = self.btnClose.bounds.size.height
        self.btnClose.frame = CGRect(x: closeX, y: closeY, width:closeWidth, height: closeHeight)
        
        let lineX: CGFloat = 10*1+closeWidth
        let lineY: CGFloat = (self.bounds.size.height-self.verticalSepLine.bounds.size.height)/2.0
        let lineWidth: CGFloat = self.verticalSepLine.bounds.size.width
        let lineHeight: CGFloat = self.verticalSepLine.bounds.size.height
        self.verticalSepLine.frame = CGRect.init(x: lineX, y: lineY, width: lineWidth, height: lineHeight)
        
        let secureX: CGFloat = 10*2+closeWidth+lineWidth
        let secureY: CGFloat = (self.bounds.size.height-self.btnSecureEye.bounds.size.height)/2.0
        let secureWidth: CGFloat = self.btnSecureEye.bounds.size.width
        let secureHeight: CGFloat = self.btnSecureEye.bounds.size.height
        self.btnSecureEye.frame = CGRect.init(x: secureX, y: secureY, width: secureWidth, height: secureHeight)
        
        self.btnClose.isHidden = true
        self.verticalSepLine.isHidden = true
        self.viewPassword?.addSubview(self.btnClose)
        self.viewPassword?.addSubview(self.verticalSepLine)
        self.viewPassword?.addSubview(self.btnSecureEye)
        self.btnSecureEye.isSelected = false
        self.isSecureTextEntry = true
        self.rightView = self.viewPassword
        self.rightViewMode = .always

    }
    
    @objc fileprivate func configVerifyCodeStyle() {
        if self.supplyText == nil {
            self.lblSupply.text = "获取验证码"
            self.supplyText = "获取验证码"
        } else {
            self.lblSupply.text = self.supplyText
        }
        if self.font != nil {
            self.lblSupply.font = self.font
        } else {
            self.lblSupply.font = UIFont.systemFont(ofSize: 17)
            
        }
        if self.supplyColor != nil {
            self.lblSupply.textColor = self.supplyColor
        } else {
            self.lblSupply.textColor = UIColor(red: 46/255.0, green: 159/255.0, blue: 1, alpha: 1)
            
        }
        let lblSize: CGSize = self.lblSupply.sizeThatFits(CGSize(width: self.bounds.size.width,height: self.bounds.size.height))
        let totalWidth: CGFloat = self.btnClose.bounds.size.width+lblSize.width+self.verticalSepLine.bounds.size.width+10*2
        self.viewVerify = UIView(frame: CGRect(x: 0,y: 0,width: totalWidth,height: self.bounds.size.height))
        let closeX: CGFloat = 0
        let closeY: CGFloat = (self.bounds.size.height-self.btnClose.bounds.size.height)/2.0
        let closeWidth: CGFloat = self.btnClose.bounds.size.width
        let closeHeight: CGFloat = self.btnClose.bounds.size.height
        self.btnClose.frame = CGRect(x: closeX,y: closeY,width: closeWidth,height: closeHeight)
        
        let lineX: CGFloat = 10*1+closeWidth
        let lineY: CGFloat = (self.bounds.size.height-self.verticalSepLine.bounds.size.height)/2.0
        let lineWidth: CGFloat = self.verticalSepLine.bounds.size.width
        let lineHeight: CGFloat = self.verticalSepLine.bounds.size.height
        self.verticalSepLine.frame = CGRect(x: lineX,y: lineY,width: lineWidth,height: lineHeight)
        
        let lblX: CGFloat = 10*2+closeWidth+lineWidth
        let lblY: CGFloat = (self.bounds.size.height-lblSize.height)/2.0
        let lblWidth: CGFloat = lblSize.width
        let lblHeight: CGFloat = lblSize.height
        self.lblSupply.frame = CGRect(x: lblX,y: lblY,width: lblWidth,height: lblHeight)
        
        self.btnClose.isHidden = true
        self.verticalSepLine.isHidden = true
        self.viewVerify?.addSubview(self.btnClose)
        self.viewVerify?.addSubview(self.verticalSepLine)
        self.viewVerify?.addSubview(self.lblSupply)
        self.rightView = self.viewVerify
        self.rightViewMode = .always
        self.viewVerify?.addGestureRecognizer(self.tapSupply)
    }
    
    @objc fileprivate func configInternationalStyle() {
        self.rightView = self.btnClose
        self.rightViewMode = .whileEditing
        
        if self.supplyText == nil {
            self.lblSupply.text = "+86"
            self.supplyText = "+86"
        } else {
            self.lblSupply.text = self.supplyText
        }
        if self.font != nil {
            self.lblSupply.font = self.font
        } else {
            self.lblSupply.font = UIFont.systemFont(ofSize: 17)
        }
        if self.supplyColor != nil {
            self.lblSupply.textColor = self.supplyColor;
        } else {
            self.lblSupply.textColor = #colorLiteral(red: 0.1803921569, green: 0.6235294118, blue: 1, alpha: 1)
        }
        
        let lblSize: CGSize = self.lblSupply.sizeThatFits(CGSize.init(width: self.bounds.size.width, height: self.bounds.size.height))
        let totalWidth: CGFloat = lblSize.width+self.imgMore.bounds.size.width+self.verticalSepLine.bounds.size.width+3*10
        self.viewInternational = UIView(frame: CGRect(x: 0, y: 0, width: totalWidth, height: self.bounds.size.height))
        
        let lblX: CGFloat = 0
        let lblY: CGFloat = (self.bounds.size.height-lblSize.height)/2.0
        let lblWidth: CGFloat = lblSize.width
        let lblHeight: CGFloat = lblSize.height
        self.lblSupply.frame = CGRect(x: lblX, y: lblY, width: lblWidth, height: lblHeight)
        
        let moreX: CGFloat = lblWidth+10
        let moreY: CGFloat = (self.bounds.size.height-self.imgMore.bounds.size.height)/2.0
        let moreWidth: CGFloat = self.imgMore.bounds.size.width
        let moreHeight: CGFloat = self.imgMore.bounds.size.height
        self.imgMore.frame = CGRect(x: moreX,y:moreY,width: moreWidth,height: moreHeight)
        
        let lineX: CGFloat = 10*2+lblWidth+moreWidth
        let lineY: CGFloat = (self.bounds.size.height-self.verticalSepLine.bounds.size.height)/2.0
        let lineWidth: CGFloat = self.verticalSepLine.bounds.size.width
        let lineHeight: CGFloat = self.verticalSepLine.bounds.size.height
        self.verticalSepLine.frame = CGRect(x: lineX, y: lineY,width: lineWidth,height: lineHeight)
        
        self.viewInternational?.addSubview(self.lblSupply)
        self.viewInternational?.addSubview(self.imgMore)
        self.viewInternational?.addSubview(self.verticalSepLine)
        self.leftView = self.viewInternational
        self.leftViewMode = .always
        self.viewInternational?.addGestureRecognizer(self.tapSupply)

    }
    
}
