import UIKit

open class WrappedViewControllerView<V, P>: View, WrappedViewControllerable where V: UIViewController, P: UIViewController {
    public let inner: V
    public let parent: P
    
    public var protocolView: View { return self }
    public var protocolController: UIViewController { return inner }
    
    public init (_ inner: V, parent: P) {
        self.inner = inner
        self.parent = parent
        parent.addChild(inner)
        super.init(frame: .zero)
        inner.didMove(toParent: parent)
        inner.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(inner.view)
        inner.view.topAnchor.constraint(equalTo: topAnchor).activated()
        inner.view.leftAnchor.constraint(equalTo: leftAnchor).activated()
        inner.view.rightAnchor.constraint(equalTo: rightAnchor).activated()
        inner.view.bottomAnchor.constraint(equalTo: bottomAnchor).activated()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        inner.view.layer.masksToBounds = true
        guard let customCorners = _declarativeView._customCorners else {
            inner.view.layer.cornerRadius = layer.cornerRadius
            return
        }
        inner.view.layer.cornerRadius = 0
        inner.view.layer.mask = layer.sublayers?.first
    }
}
