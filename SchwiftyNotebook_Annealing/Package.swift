// swift-tools-version:4.2
import PackageDescription

let package = Package(
name: "SchwiftyNotebook_Annealing",
products: [
.library(name: "SchwiftyNotebook_Annealing", targets: ["SchwiftyNotebook_Annealing"]),

],
dependencies: [
.package(path: "../SchwiftyNotebook_Layer_Refined")
],
targets: [
.target(name: "SchwiftyNotebook_Annealing", dependencies: ["SchwiftyNotebook_Layer_Refined"]),

]
)