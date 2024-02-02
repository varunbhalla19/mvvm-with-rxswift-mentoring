//
//  Copyright © 2020 Essential Developer Ltd. All rights reserved.
//

import RxCocoa
import Differentiator

public struct FieldViewModel {
    public let title: String
    public let text: BehaviorRelay<String>
    public let query: BehaviorRelay<String>
    public let focus = PublishRelay<Void>()
    public let editingDidEnd = PublishRelay<Void>()
        
    public init(title: String = "", text: String? = "") {
        self.title = title
        self.text = BehaviorRelay<String>(value: text ?? "")
        self.query = BehaviorRelay<String>(value: "")
    }
}

extension FieldViewModel: Equatable {
    public static func == (lhs: FieldViewModel, rhs: FieldViewModel) -> Bool {
        lhs.title == rhs.title && lhs.text.value == rhs.text.value
    }
}

extension FieldViewModel: IdentifiableType {
    public var identity: String { title }
}

extension FieldViewModel {
    public static func iban(text: String? = "") -> FieldViewModel {
        return FieldViewModel(title: "IBAN", text: text)
    }
    
    public static func taxNumber(text: String? = "") -> FieldViewModel {
        return FieldViewModel(title: "Tax number", text: text)
    }
    
    public static func bankName(text: String? = "") -> FieldViewModel {
        return FieldViewModel(title: "Bank name", text: text)
    }
    
    public static func comment(text: String? = "") -> FieldViewModel {
        return FieldViewModel(title: "Comment", text: text)
    }
}
