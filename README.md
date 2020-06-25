# DMSwift


[![Swift Version](https://img.shields.io/badge/Swift-5-orange.svg)]()
[![CI Status](https://img.shields.io/travis/sh-khashimov/DMSwift.svg?style=flat)](https://travis-ci.org/sh-khashimov/RESegmentedControl)
[![Version](https://img.shields.io/cocoapods/v/DMSwift.svg?label=version)](https://cocoapods.org/pods/DMSwift)
![Support](https://img.shields.io/badge/supports-SPM%2C%20CocoaPods-green.svg)
![Platform](https://img.shields.io/badge/platforms-ios%20|%20osx%20|%20watchos%20|%20tvos%20|%20linux-lightgrey.svg?style=flat)
![Documentation](./docs/badge.svg?style=flat&sanitize=true)


DMSwift provides a simple and efficient way to download files.

| | Main Features |
|---|---|
| ⛓ | Simultaneously downloads a large number of files |
| 🚦 | Concurrently post-process downloaded files |
| 👮 | Monitors the progress of downloading and post processing |
| 🧘‍♂️ | Flexible configuration and easy to use API |
| 🧩 | Unit tested |
| 🚀 | Written in Swift |

## Getting Started
- [**Getting started guide**](/Documentation/GettingStarted.md)
- [**DMSwift in-depth**](/Documentation/DMSwift_inDepth.md)
- [**How Post-process works**](/Documentation/PostProcessing.md)
- [**Available Post-processes**](/Documentation/Available_PostProcesses.md)
- [**Example projects**](/Examples)

## Installation

When you are ready to install, follow the [**Installation Guide**](/Documentation/Installation.md).

## Documentation

You can find <a href="https://sh-khashimov.github.io/DMSwift/" target="_blank">**the docs here**</a>. Documentation is generated with [jazzy](https://github.com/realm/jazzy) and hosted on [GitHub-Pages](https://pages.github.com/).

<a name="h_requirements"></a>
## Requirements


| App version | Swift | Xcode | Platforms |
|---|---|---|---|
| current version | Swift 5.0 | Xcode 11 | iOS 8.0 / watchOS 2.0 / macOS 10.10 / tvOS 9.0 / Ubuntu |


<a name=“h_todo></a>
## Todo

- [ ] Resumable downloads
- [ ] Faillable Retry pattern
- [ ] Split the download to in 2-3 threads
- [ ] Real-time speed metrics

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.


## Inspiration

- [WWDC 2015: Advanced NSOperations](https://developer.apple.com/videos/play/wwdc2015/226/)

## Author

Sherzod Khashimov

## License
[MIT](https://choosealicense.com/licenses/mit/)