# ScrollViewController
Scroll View Controller made to simplify scroll view management where complex scrollable forms are required.

# About
Scroll View Controller acts as container view controller for content that needs to be scrollable. It automatically installs all needed constraints, flashes scroll indicators and adjusts scroll view's instets. Generated scroll view have disabled delay for content touches to allow buttons to have correct animation and touch behavour.

Child view controllers can implement `ScrollableViewController` protocol to obtain access to the presenting scroll view controller instance.

# Usage

```swift
class MyCustomViewController : UIViewContoroller, ScrollableViewController {

    weak var scrollViewController: ScrollViewController?

}

let viewController = MyCustomViewController()
let scrollViewController = ScrollViewController(contentController: viewController)
self.navigationController.pushViewController(scrollViewController, animated: true)
```
