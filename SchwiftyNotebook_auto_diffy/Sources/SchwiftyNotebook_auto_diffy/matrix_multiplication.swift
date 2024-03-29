/*
THIS FILE WAS AUTOGENERATED! DO NOT EDIT!
file to edit: matrix_multiplication.ipynb

*/



import Path
import TensorFlow

public func normalizeTensor<T:TensorFlowFloatingPoint>(tensor: Tensor<T>)-> Tensor<T>{
    return (tensor - tensor.mean())/tensor.standardDeviation()
}

extension Bool {
    var symbol: String {
        return self ? "😈" : "👿"
    }
}

public struct AssertionError: Error {
    let message: String
    init(_ message: String){
        self.message = message
    }
}

public func assert(toAssert: Bool, message: String = "Not True!") throws {
    if(!toAssert){
        throw AssertionError(message)
    }
}

public extension StringTensor {
    // Read a file into a Tensor.
    init(readFile filename: String) {
        self.init(readFile: StringTensor(filename))
    }
    init(readFile filename: StringTensor) {
        self = Raw.readFile(filename: filename)
    }

    // Decode a StringTensor holding a JPEG file into a Tensor<UInt8>.
    func decodeJpeg(channels: Int = 0) -> Tensor<UInt8> {
        return Raw.decodeJpeg(contents: self, channels: Int64(channels), dctMethod: "") 
    }
}
