# JetLayout

[![CI Status](https://img.shields.io/travis/vbenkevich/JetLayout.svg?style=flat)](https://travis-ci.org/vbenkevich/JetLayout)
[![Version](https://img.shields.io/cocoapods/v/JetLayout.svg?style=flat)](https://cocoapods.org/pods/JetLayout)
[![License](https://img.shields.io/cocoapods/l/JetLayout.svg?style=flat)](https://cocoapods.org/pods/JetLayout)
[![Platform](https://img.shields.io/cocoapods/p/JetLayout.svg?style=flat)](https://cocoapods.org/pods/JetLayout)

JetLayout is a swift based layout system. It has a syntax like SwiftUI, but JetLayout could be used with iOS 11.
Layout engine is based on Autolayout, so JetLayout's widgets could be easily integrated into an existing application.
RxSwift is used to wiring UI and data.
Since all layouts has written in code it possible to use plugins like R.swift to provide strong typed access to assets.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

Sample of the layout:
```swift
VStack(spacing: 8) {
    Image(#imageLiteral(resourceName: "Logo"))
    
    Text("Email").addMargin(top: 8)
    Field(viewModel.$email)
        .contentType(.emailAddress)
        .placeholder("email@example.com")

    Text("Password").addMargin(top: 8)
    Field(viewModel.$password)
        .isSecureTextEntry(true)
        .placeholder("strong password")
        .addMargin(bottom: 24)
    
    Button(type: .system, title: "Sign In")
        .corner(radius: 8)
        .size(height: 32)
        .font(.boldSystemFont(ofSize: 16))
        .align(left: 16, right: 16)
}
```

Sample of wrapping existing UIView into Widget:
```swift
Widget(UIActivityIndicatorView())
    .alignment(.center())
    // setup before adding to layout
    .setup(block: { view in
        view.hidesWhenStopped = true
        view.color = .red
    })
    // UIView hold reference to the dispose bag
    .bind(viewModel.$showActivity) { (view, show) in
        if (show) {
            view.startAnimating()
        } else {
            view.stopAnimating()
        }
    }
```

Complex UI can be easily separated into small blocks: 
```swift
struct AddItemView: View {
    
    let onAddClicked: (String) -> Void
    
    @Observed
    private var itemName: String? = "Add new item"

    var body: Layout {
        HStack(spacing: 16) {
            Field(self.$itemName).placeholder("Item mame")
            
            Button(type: .contactAdd)
                .disabled(source: self.$itemName.isEmpty)
                .tap {
                    self.onAddClicked(self.itemName ?? "")
                    self.itemName = ""
                }
        }
    }
}
```

TableView example:
```swift
struct ItemsTable: View {
    
    let items: Observed<[String]>
    
    var body: Layout {
        Table {
            // Cells registration
            ItemCell.register()
            
            // Static section at top
            TSection {
                Image(#imageLiteral(resourceName: "Logo"))
                    .alignment(.fill())
                    .size(height: 80)
                    .contentMode(.scaleAspectFit)
            }
            
            // Dynamic section
            TSection(source: self.items)
        }
        .preserveParentPadding()
    }
}

class ItemCell: ViewBasedTableCell<String> {
    
    override var view: View {
        HStack {
            Text(self.$model)
        }
        .preserveParentPadding()
    }
}

```

Wiring previuos views toogether and inserting layout to UIViewController:
```swift

@Observed
var items: [String] = []

override func viewDidLoad() {
    super.viewDidLoad()
    title = "Dynamic table view"
    
    VStack(spacing: 24) {
        AddItemView { [weak self] in self?.items.append($0) }
        
        ItemsTable(items: self.$items)
    }
    .root(of: self)
}
```

Support autolayout features like margins and preserving parent/safearea margins. View could be alligned both superview's bounds and superview's margins:
```swift

ZStack {
    // View 20x20 in the top-right corner. distance to top = 10, distance to rignt = 0
    Empty(color: .green, size: CGSize(width: 20, height: 20))
        .alignment(Alignment.top().right())
        .align(topPadding: true, rightPadding: false)
    
    // this stack alligned to superview's bounds but preserve superview paddings
    HStack {
        Empty(color: .red)
            .align(toPadding: false)
            .align(leftPadding: true)
        
        Empty(color: .blue)
            .align(bottomPadding: false)
    }
    .distribution(.fillEqually)
    .preserveParentPadding()
}
.preserveParentPadding() // keep safe area and viewController margins
.padding(10) //adding self padding (at least 10) result padding for root view in VC will: (10, 20, 10 ,20)
```

## Requirements

iOS 11
swift 5

## Installation

JetLayout is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JetLayout'
```

## Author

## License

JetLayout is available under the MIT license. See the LICENSE file for more info.
