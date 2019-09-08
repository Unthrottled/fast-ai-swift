// swift-tools-version:4.2
import PackageDescription

let package = Package(
name: "SchwiftyNotebook_matrix_multiplication",
products: [
.library(name: "SchwiftyNotebook_matrix_multiplication", targets: ["SchwiftyNotebook_matrix_multiplication"]),

],
dependencies: [
.package(path: "../SchwiftyNotebook_initial_setup")
],
targets: [
.target(name: "SchwiftyNotebook_matrix_multiplication", dependencies: ["SchwiftyNotebook_initial_setup"]),

]
)