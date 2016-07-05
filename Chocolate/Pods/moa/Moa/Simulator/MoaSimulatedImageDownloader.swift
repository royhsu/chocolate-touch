import Foundation

/**

Simulates download of images in unit test. This downloader is used instead of the HTTP downloaded when the moa simulator is started: MoaSimulator.start().

*/
public final class MoaSimulatedImageDownloader: MoaImageDownloader {
  
  /// Url of the downloader.
  public let url: String
  
  /// Indicates if the request was cancelled.
  public var cancelled = false
  
  var autorespondWithImage: MoaImage?
  
  var autorespondWithError: (error: NSError?, response: HTTPURLResponse?)?
  
  var onSuccess: ((MoaImage)->())?
  var onError: ((NSError, HTTPURLResponse?)->())?

  init(url: String) {
    self.url = url
  }
  
  func startDownload(_ url: String, onSuccess: (MoaImage)->(),
    onError: (NSError?, HTTPURLResponse?)->()) {
      
    self.onSuccess = onSuccess
    self.onError = onError
      
    if let autorespondWithImage = autorespondWithImage {
      respondWithImage(autorespondWithImage)
    }
      
    if let autorespondWithError = autorespondWithError {
      respondWithError(autorespondWithError.error, response: autorespondWithError.response)
    }
  }
  
  func cancel() {
    cancelled = true
  }
  
  /**
  
  Simulate a successful server response with the supplied image.
  
  - parameter image: Image that is be passed to success handler of all ongoing requests.
  
  */
  public func respondWithImage(_ image: MoaImage) {
    onSuccess?(image)
  }
  
  /**
  
  Simulate an error response from server.
  
  - parameter error: Optional error that is passed to the error handler ongoing request.
  
  - parameter response: Optional response that is passed to the error handler ongoing request.
  
  */
  public func respondWithError(_ error: NSError? = nil, response: HTTPURLResponse? = nil) {
    onError?(error ?? MoaError.simulatedError.nsError, response)
  }
}
