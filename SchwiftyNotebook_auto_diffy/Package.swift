// swift-tools-version:4.2
import PackageDescription

let package = Package(
name: "SchwiftyNotebook_auto_diffy",
products: [
.library(name: "SchwiftyNotebook_auto_diffy", targets: ["SchwiftyNotebook_auto_diffy"]),

],
dependencies: [
.package(path: "../SchwiftyNotebook_convolution_model")
],
targets: [
.target(name: "SchwiftyNotebook_auto_diffy", dependencies: ["SchwiftyNotebook_convolution_model"]),

]
)