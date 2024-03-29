/*
THIS FILE WAS AUTOGENERATED! DO NOT EDIT!
file to edit: convolution_model.ipynb

*/



import Path
import TensorFlow
import SchwiftyNotebook_matrix_multiplication

public func reLU<T>(tensor: Tensor<T>) -> Tensor<T> where T : FloatingPoint, T: TensorFlowScalar {
    return max(tensor, 0)
}

public func linearCombination<T>(inputs: Tensor<T>, weights: Tensor<T>, bias: Tensor<T>) -> Tensor<T> where T: FloatingPoint, T: TensorFlowScalar {
    return matmul(inputs, weights) + bias
}

public typealias TensorFloat=Tensor<Float>
public func assertNearZero(_ tensor: TensorFloat, _ threshold: Float = 1e-3){
    assert(tensor < threshold, "Expected \(tensor) to be less than \(threshold)")
}

import Dispatch

public func getTimeUnit(_ nanoSeconds: Double) -> String {
    let powerOfTen = floor(log10(nanoSeconds))
    switch powerOfTen {
        case 1..<3:
            return "\(nanoSeconds) ns"
        case 3..<6:
            return "\(nanoSeconds/1e3) µs"
        case 6..<9: 
            return "\(nanoSeconds/1e6) ms"
        default: 
            return "\(nanoSeconds/1e9) s"
    }
}

// ⏰Time how long it takes to run the specified function, optionally taking
// the average across a number of repetitions.
public func withTime<T>(_ f: () -> T) -> T {
    let start = DispatchTime.now()
    let value = f()
    let end = DispatchTime.now()
    let nanoSeconds = Double(end.uptimeNanoseconds - start.uptimeNanoseconds)
    print("elapsed time: \(getTimeUnit(nanoSeconds))")
    return value
}

public func timeTrials(trials: Int = 1, _ f: () -> ()) {
    guard trials > 0 else { return }
    
    // Warmup
    if trials > 1 { f() }
    
    var times = [Double]()
    for _ in 1...trials {
        let start = DispatchTime.now()
        f()
        let end = DispatchTime.now()
        let nanoseconds = Double(end.uptimeNanoseconds - start.uptimeNanoseconds)
        times.append(nanoseconds)
    }
    print("average: \(getTimeUnit(times.reduce(0.0, +)/Double(times.count))),   " +
          "min: \(getTimeUnit(times.reduce(times[0], min))),   " +
          "max: \(getTimeUnit(times.reduce(times[0], max)))")
}

public func assertEquals(_ a: TensorFloat, _ b: TensorFloat, _ message: String) {
    // Check shapes match so broadcasting doesn't hide shape errors.
    assert(a.shape == b.shape)
    assertNearZero(a-b)
}

public func squaredWithGradient(inputTensor: TensorFloat) -> (value: TensorFloat, 
                                                       gradientChain: (TensorFloat) -> TensorFloat) {
    return (value: inputTensor * inputTensor, 
            gradientChain: {ddx in 2 * inputTensor * ddx})
}

public func meanWithGradient(inputTensor: TensorFloat) -> (value: TensorFloat, 
                                                       gradientChain: (TensorFloat) -> TensorFloat) {
 let totalElements = Float(inputTensor.shape.dimensions.reduce(1) { accum, thing in accum * thing })
 return (value: inputTensor.sum(squeezingAxes: Array(inputTensor.shape.indices)) / totalElements,
         gradientChain: {ddx in TensorFloat([1]) / totalElements * ddx})   
}

public func reLUAndGradient(inputTensor: TensorFloat) -> (value: TensorFloat, 
                                                   gradientChain: (TensorFloat) -> TensorFloat){
    return (value: max(0.0, inputTensor), 
            gradientChain: {ddx in ddx.replacing(with: TensorFloat(zeros: ddx.shape), where: inputTensor .< 0.0 )})
}

public func leakyRelu<T: TensorFlowFloatingPoint>(inputTensor: Tensor<T>,
                                           negativeSlope: Double) -> Tensor<T> {
    return max(0, inputTensor) + T(negativeSlope) * min(0, inputTensor)
}

public func leakyReLUAndGradient(inputTensor: TensorFloat,
                          negativeSlope: Double = 0.0) -> (value: TensorFloat,
                                                   // We only really care about the derivative with respect to the input
                                                   gradientChain: (TensorFloat) -> TensorFloat){
    return (value: leakyRelu(inputTensor: inputTensor, negativeSlope: negativeSlope), 
            gradientChain: {ddx in ddx.replacing(with: TensorFloat(zeros: ddx.shape), where: inputTensor .< 0.0 )})
}


// Matrix Shapez
// M x N * N x O = M x O

// ddx shape = M x O

public func linearCombinationAndGradient(inputTensor: TensorFloat, 
                                  weightParameter: TensorFloat,
                                  biasParameter: TensorFloat) -> (value: TensorFloat, 
                                                                  gradientChain: (TensorFloat) -> (TensorFloat, TensorFloat, TensorFloat)) {
    return (value: matmul(inputTensor, weightParameter) + biasParameter, 
            gradientChain: { ddx in 
                           ( matmul(ddx, weightParameter.transposed()),
                             matmul(inputTensor.transposed(),  ddx),
                             ddx.unbroadcasted(to: biasParameter.shape)
                           )
                           })
}

public extension Tensor where Scalar: TensorFlowFloatingPoint {
    init(kaimingUniform shape: TensorShape, negativeSlope: Double = 1.0) {
        // Assumes Leaky ReLU nonlinearity
        let gain = Scalar.init(TensorFlow.sqrt(2.0 / (1.0 + TensorFlow.pow(negativeSlope, 2))))
        let spatialDimCount = shape.count - 2
        let receptiveField = shape[0..<spatialDimCount].contiguousSize
        let fanIn = shape[shape.count - 2] * receptiveField
        let bound = TensorFlow.sqrt(Scalar(3.0)) * gain / TensorFlow.sqrt(Scalar(fanIn))
        self = bound * (2 * Tensor(randomUniform: shape, generator: &PhiloxRandomNumberGenerator.global) - 1)
    }
}


// loss function
public func meanSquaredErrorAndGradient(yHat: TensorFloat, y: TensorFloat) -> (value: TensorFloat,
                                                                        gradient: () -> TensorFloat) {
    assert(yHat.shape == y.shape, "Expected inputs to be the same size")
    let error = yHat - y
    let (squareValue, squareGradient) = squaredWithGradient(inputTensor: error)
    let (meanValue, meanGradient) = meanWithGradient(inputTensor: squareValue)
    
    return (value: meanValue, gradient: { squareGradient(meanGradient(TensorFloat([1]))) })
}
