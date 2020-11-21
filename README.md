# Blaze
![CI](https://github.com/ivanlisovyi/blaze/workflows/CI/badge.svg)

Blaze is a CLI tool that helps you to: 
- Donwload Firebase Remote Config 
- Optionally transform Firebase Remote Config with the help of built-in transforms

## Installation 
### Swift Package Manager 
Create `Package.swift` in the `BuildTools` folder with the following content 
```swift 
// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "BuildTools",
    platforms: [ 
        .macOS(.v10_15)
    ] ,
    dependencies: [
        .package(
            url: "https://github.com/ivanlisovyi/blaze",
            from: "0.0.1"
        ),
    ],
    targets: [
        .target(name: "BuildTools")
    ]
)
```

In the `BuildTools` folder create a file called `Empty.swift` with nothing in it. This is to satisfy a change in Swift Package Manager.

## Usage 
You can call `blaze` from the command line: 
```sh
swift run -c release --package-path BuildTools blaze -c $PATH_TO_CONFIG -o $OUTPUT_PATH -t flattening
```

## Built-in Transforms
- Flattening - flattens the structure of the Remote Config file. 
- FlatteningPlist - flattens the structure of Remote Config file and transforms the output to `.plist` file. 

## License 
MIT License

Copyright (c) 2020 Ivan Lisovyi

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.