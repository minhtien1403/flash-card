//
//  View+.swift
//  FlashCard
//
//  Created by tientm on 19/12/2023.
//

import SwiftUI

extension View {
    
    func toAnyView() -> AnyView {
        AnyView(self)
    }
    
    func hideNavigationBarBackButton() -> some View {
        self.modifier(NavigationBarBackButtonTitleHiddenModifier())
    }
    
    func navigationBarLargeTitleItems<L>(trailing: L) -> some View where L : View {
        overlay(NavigationBarLargeTitleItems(trailing: trailing).frame(width: 0, height: 0))
    }
    
    public func popup<PopupContent: View>(
        isPresented: Binding<Bool>,
        view: @escaping () -> PopupContent) -> some View {
        self.modifier(
            Popup(
                isPresented: isPresented,
                view: view)
        )
    }
    
    func frameGetter(_ frame: Binding<CGRect>) -> some View {
        modifier(FrameGetter(frame: frame))
    }
}

fileprivate struct FrameGetter: ViewModifier {
  
    @Binding var frame: CGRect
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy -> AnyView in
                    let rect = proxy.frame(in: .global)
                    // This avoids an infinite layout loop
                    if rect.integral != self.frame.integral {
                        DispatchQueue.main.async {
                            self.frame = rect
                        }
                    }
                return AnyView(EmptyView())
            })
    }
}

fileprivate struct NavigationBarBackButtonTitleHiddenModifier: ViewModifier {
    
    @Environment(\.dismiss) var dismiss
    
    @ViewBuilder @MainActor func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .contentShape(Rectangle()) // Start of the gesture to dismiss the navigation
            .gesture(
                DragGesture(coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.width > .zero
                            && value.translation.height > -30
                            && value.translation.height < 30 {
                            dismiss()
                        }
                    }
            )
    }
}

fileprivate struct NavigationBarLargeTitleItems<L : View>: UIViewControllerRepresentable {
    typealias UIViewControllerType = Wrapper
    
    private let trailingItems: L
    
    init(trailing: L) {
        self.trailingItems = trailing
    }
    
    func makeUIViewController(context: Context) -> Wrapper {
        Wrapper(representable: self)
    }
    
    func updateUIViewController(_ uiViewController: Wrapper, context: Context) {
    }
    
    class Wrapper: UIViewController {
        private let representable: NavigationBarLargeTitleItems?
        
        init(representable: NavigationBarLargeTitleItems) {
            self.representable = representable
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            self.representable = nil
            super.init(coder: coder)
        }
                
        override func viewWillAppear(_ animated: Bool) {
            guard let representable = self.representable else { return }
            guard let navigationBar = self.navigationController?.navigationBar else { return }
            guard let UINavigationBarLargeTitleView = NSClassFromString("_UINavigationBarLargeTitleView") else { return }
           
            navigationBar.subviews.forEach { subview in
                if subview.isKind(of: UINavigationBarLargeTitleView.self) {
                    let controller = UIHostingController(rootView: representable.trailingItems)
                    controller.view.translatesAutoresizingMaskIntoConstraints = false
                    subview.addSubview(controller.view)
                    
                    NSLayoutConstraint.activate([
                        controller.view.bottomAnchor.constraint(
                            equalTo: subview.bottomAnchor,
                            constant: -150
                        ),
                        controller.view.trailingAnchor.constraint(
                            equalTo: subview.trailingAnchor,
                            constant: view.directionalLayoutMargins.trailing
                        )
                    ])
                }
            }
        }
    }
}
