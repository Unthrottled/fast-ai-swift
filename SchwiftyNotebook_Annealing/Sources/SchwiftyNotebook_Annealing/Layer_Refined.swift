/*
THIS FILE WAS AUTOGENERATED! DO NOT EDIT!
file to edit: Layer_Refined.ipynb

*/



import Path
import TensorFlow
import SchwiftyNotebook_batch_boi

public typealias SingleValueAndGradientChain<T>=(value: T, gradientChain: (T) -> T )
public typealias SingleInputDifferentiable<T> = (T) -> SingleValueAndGradientChain<T>

public let identititySVGC: SingleInputDifferentiable<TensorFloat> = { x in (value: x, gradientChain: { y in y }) }

public struct HyperParameter {
    let learningRate: Float
    
    init(learningRate: Float){
        self.learningRate = learningRate
    }
}

public struct RuntimeError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}

public protocol ModelParameter  {
    
    func forwardPass(inputTensor: TensorFloat) -> (TensorFloat, ModelParameter)
    
    func apply(_ inputTensor: TensorFloat) -> TensorFloat 
    
    func backwardPass(ddx: TensorFloat, hyperParameters: HyperParameter) -> (TensorFloat, ModelParameter)
}

public typealias ThreeInputGradient = (TensorFloat) -> (TensorFloat, TensorFloat, TensorFloat)

public struct DenseLayer: ModelParameter {
    let activationFunction: SingleInputDifferentiable<TensorFloat>
    let weightParameter: TensorFloat
    let biasParameter: TensorFloat
    private let gradientChain: ThreeInputGradient

    private init(activationFunction: @escaping SingleInputDifferentiable<TensorFloat>,
                 weightParameter: TensorFloat,
                 biasParameter: TensorFloat,
                 gradientChain: @escaping ThreeInputGradient) {
        self.activationFunction = activationFunction
        self.weightParameter = weightParameter
        self.biasParameter = biasParameter
        self.gradientChain = gradientChain
    }

    private init(denseLayer: DenseLayer,
                 gradientChain: @escaping ThreeInputGradient) {
        self.activationFunction = denseLayer.activationFunction
        self.weightParameter = denseLayer.weightParameter
        self.biasParameter = denseLayer.biasParameter
        self.gradientChain = gradientChain
    }

    init(inputSize: Int,
         outputSize: Int,
         activationFunction: @escaping SingleInputDifferentiable<TensorFloat> = identititySVGC){
        self.activationFunction = activationFunction
        self.weightParameter = TensorFloat(kaimingUniform: TensorShape([inputSize, outputSize]))
        self.biasParameter = TensorFloat(zeros: [outputSize])
        self.gradientChain = { (x: TensorFloat)  in (TensorFloat([1]), TensorFloat([1]), TensorFloat([1]))}
    }

    public func forwardPass(inputTensor: TensorFloat) -> (TensorFloat, ModelParameter) {
        let (parameterOutput, parameterGradientChain) =
          linearCombinationAndGradient(inputTensor: inputTensor,
                                       weightParameter: self.weightParameter,
                                       biasParameter: self.biasParameter)
        let (activations, activationsGradientChain) = activationFunction(parameterOutput)

        return (activations, DenseLayer(denseLayer: self,
                                       gradientChain: {ddx in parameterGradientChain(activationsGradientChain(ddx))}))
    }

    public func apply(_ inputTensor: TensorFloat) -> TensorFloat {
        let parameterOutput =
          linearCombination(inputs: inputTensor,
                                       weights: self.weightParameter,
                                       bias: self.biasParameter)
        let (activations, activationsGradientChain) = activationFunction(parameterOutput)
        return activations
    }

    public func backwardPass(ddx: TensorFloat, hyperParameters: HyperParameter) -> (TensorFloat, ModelParameter) {
        let (ddxInput, ddxParameter, ddxBias) = self.gradientChain(ddx)
        return (ddxInput, DenseLayer(activationFunction: activationFunction,
                                    weightParameter: self.weightParameter - hyperParameters.learningRate * ddxParameter,
                                    biasParameter: self.biasParameter - hyperParameters.learningRate * ddxBias,
                                    gradientChain: self.gradientChain))
    }
}
