// swift-tools-version:4.2
import PackageDescription

let package = Package(
name: "SchwiftyNotebook_convolution_model",
products: [
.library(name: "SchwiftyNotebook_convolution_model", targets: ["SchwiftyNotebook_convolution_model"]),

],
dependencies: [
.package(path: "../SchwiftyNotebook_matrix_multiplication")
],
targets: [
.target(name: "SchwiftyNotebook_convolution_model", dependencies: ["SchwiftyNotebook_matrix_multiplication"]),

]
)