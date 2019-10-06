/*
THIS FILE WAS AUTOGENERATED! DO NOT EDIT!
file to edit: auto_diffy.ipynb

*/



import Path
import TensorFlow
import SchwiftyNotebook_convolution_model

public func denseLayerCombination(inputTensor: TensorFloat, 
                     weightParameter: TensorFloat, 
                     biasParameter: TensorFloat) -> TensorFloat {
    return matmul(inputTensor, weightParameter) + biasParameter
}

@differentiating(denseLayerCombination)
public func denseLayerCombinationGradient(inputParameter: TensorFloat, 
                        weightParameter: TensorFloat, 
                        biasParameter: TensorFloat) -> (value: TensorFloat, 
                                                        pullback: (TensorFloat) -> 
                                                        (TensorFloat, TensorFloat, TensorFloat)) {
    //M x N * N x O = M x O
    return (value: denseLayerCombination(inputTensor: inputParameter, 
                                   weightParameter: weightParameter, 
                                   biasParameter: biasParameter), 
            pullback: { ddx in (
                            inputParameter,
                            matmul(inputParameter.transposed(), ddx),
                            ddx.unbroadcasted(to: biasParameter.shape)) 
                          }
           )
}

@differentiable
public func squaredTensor(inputTensor: TensorFloat) -> TensorFloat {
    return inputTensor * inputTensor
}

@differentiable
public func meanOfTensor(inputTensor: TensorFloat) -> TensorFloat {
    return inputTensor.mean()
}

@differentiable
public func squaredMeanOfTensor(inputTensor: TensorFloat) -> TensorFloat {
    return meanOfTensor(inputTensor: squaredTensor(inputTensor: inputTensor))
}

public func leakyReLU(inputTensor: TensorFloat,
                                           negativeSlope: Float) -> TensorFloat {
    return max(0, inputTensor) + negativeSlope * min(0, inputTensor)
}

@differentiating(leakyReLU)
public func leakyReLUGradient(inputTensor: TensorFloat, 
                              negativeSlope: Float = 0.0) -> (value: TensorFloat, 
                                                               pullback: (TensorFloat) -> 
                                                                       (TensorFloat, Float)) {
    let leakyActivations = leakyReLU(inputTensor: inputTensor, negativeSlope: negativeSlope)
    return (value: leakyActivations, 
            pullback: { (ddx: TensorFloat) in (ddx.unbroadcasted(to: inputTensor.shape), negativeSlope)})
}
