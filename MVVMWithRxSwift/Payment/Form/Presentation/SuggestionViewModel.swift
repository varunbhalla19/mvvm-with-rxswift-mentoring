//
//  Copyright © 2020 Essential Developer Ltd. All rights reserved.
//

import RxCocoa
import RxSwift
import Differentiator

public struct SuggestionViewModel {
    public let text: String
    public let select: PublishRelay<Void>
    private let bag = DisposeBag()
    
    public init(_ suggestion: Suggestion, select: PublishRelay<Suggestion>) {
        switch (suggestion.iban, suggestion.taxNumber) {
        case let (.some(iban), .some(taxNumber)):
            self.text = "Iban: \(iban) | Tax number: \(taxNumber)"
        case let (.none, .some(taxNumber)):
            self.text = "Tax number: \(taxNumber)"
        case let (.some(iban), .none):
            self.text = "Iban: \(iban)"
        default:
            self.text = ""
        }
        self.select = PublishRelay()
        self.select.map { _ in suggestion }.bind(to: select).disposed(by: bag)
    }
}

extension SuggestionViewModel: Equatable {
    public static func == (lhs: SuggestionViewModel, rhs: SuggestionViewModel) -> Bool {
        lhs.text == rhs.text
    }
}

extension SuggestionViewModel: IdentifiableType {
    public var identity: String { text }
}
