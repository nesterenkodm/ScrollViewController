# ScrollViewController
Scroll View Controller made to simplify scroll view management where complex scrollable forms are required.

# About
Scroll View Controller acts as container view controller for content that needs to be scrollable. It automatically installs all needed constraints, flashes scroll indicators and adjusts scroll view's instets.

# Usage

```swift
let viewController = MyCustomViewController()
let scrollViewController = ScrollViewController(contentController: viewController)
self.navigationController.pushViewController(scrollViewController, animated: true)
```
