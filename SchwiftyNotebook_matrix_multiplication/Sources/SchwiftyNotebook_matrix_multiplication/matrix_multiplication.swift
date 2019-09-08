/*
THIS FILE WAS AUTOGENERATED! DO NOT EDIT!
file to edit: matrix_multiplication.ipynb

*/



import Path
import TensorFlow

func normalizeTensor<T:TensorFlowFloatingPoint>(tensor: Tensor<T>)-> Tensor<T>{
    return (tensor - tensor.mean())/tensor.standardDeviation()
}

extension Bool {
    var symbol: String {
        return self ? "😈" : "👿"
    }
}

struct AssertionError: Error {
    let message: String
    init(_ message: String){
        self.message = message
    }
}

func assert(toAssert: Bool, message: String = "Not True!") throws {
    if(!toAssert){
        throw AssertionError(message)
    }
}
