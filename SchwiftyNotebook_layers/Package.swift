// swift-tools-version:4.2
import PackageDescription

let package = Package(
name: "SchwiftyNotebook_layers",
products: [
.library(name: "SchwiftyNotebook_layers", targets: ["SchwiftyNotebook_layers"]),

],
dependencies: [
.package(path: "../SchwiftyNotebook_matrix_multiplication")
],
targets: [
.target(name: "SchwiftyNotebook_layers", dependencies: ["SchwiftyNotebook_matrix_multiplication"]),

]
)