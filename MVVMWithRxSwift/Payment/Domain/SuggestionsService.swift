//
//  Copyright © 2020 Essential Developer Ltd. All rights reserved.
//

import RxSwift

public protocol SuggestionsService {
    func perform(request: SuggestionsRequest) -> Single<[Suggestion]>
}

public struct SuggestionsRequest {
    public let query: String
    
    public init(query: String) {
        self.query = query
    }
}

public struct FailableService: SuggestionsService {
    public init() {}
    public func perform(request: SuggestionsRequest) -> Single<[Suggestion]> {
        .error(NSError(domain: "Custom", code: 404))
    }
}
