//
//  Copyright © 2020 Essential Developer Ltd. All rights reserved.
//

import RxCocoa
import RxSwift

public struct PaymentFormViewModel {
    public enum State: Equatable {
        case fields([FieldViewModel])
        case focus(FieldViewModel, [SuggestionViewModel])
    }

    private let bag: DisposeBag = DisposeBag()
    private let iban: FieldViewModel
    private let taxNumber: FieldViewModel
    private let bankName: FieldViewModel
    private let comment: FieldViewModel
    private let service: SuggestionsService
    private let suggestionSelection = PublishRelay<Suggestion>()
    
    public init(
        iban: FieldViewModel = .iban(),
        taxNumber: FieldViewModel = .taxNumber(),
        bankName: FieldViewModel = .bankName(),
        comment: FieldViewModel = .comment(),
        service: SuggestionsService
    ) {
        self.iban = iban
        self.taxNumber = taxNumber
        self.bankName = bankName
        self.comment = comment
        self.service = service
        
        suggestionSelection.compactMap(\.taxNumber).bind(to: taxNumber.text).disposed(by: bag)
        suggestionSelection.compactMap(\.iban).bind(to: iban.text).disposed(by: bag)
        suggestionSelection.map { _ in "" }.bind(to: taxNumber.query, iban.query).disposed(by: bag)
    }

    public var state: Observable<State> {
        let allFields = State.fields([iban, taxNumber, bankName, comment])
        return Observable.merge(
            focus(for: iban),
            focus(for: taxNumber),
            search(for: iban),
            search(for: taxNumber),
            editingEnd(for: iban),
            editingEnd(for: taxNumber),
            suggestionSelection.map { _ in
                allFields
            },
            .just(allFields)
        )
    }
    
    private func search(for field: FieldViewModel) -> Observable<State> {
        field.query
            .distinctUntilChanged()
            .skip(1)
            .flatMapLatest { [service] query in
                query.isEmpty
                    ? Observable.just([])
                    : service.perform(request: .init(query: query))
                        .asObservable()
                        .catchAndReturn([Suggestion]())
            }.map { [suggestionSelection] suggestions in
                .focus(field, suggestions.map {
                    SuggestionViewModel($0, select: suggestionSelection)
                })
            }
    }
    
    private func focus(for field: FieldViewModel) -> Observable<State> {
        field.focus.map {
            .focus(field, [])
        }
    }
    
    private func editingEnd(for field: FieldViewModel) -> Observable<State> {
        field.editingDidEnd.map {
            .fields([iban, taxNumber, bankName, comment])
        }
    }
}
