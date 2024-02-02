//
//  Copyright © 2020 Essential Developer Ltd. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import MVVMWithRxSwift

class PaymentFormViewModelTests: XCTestCase {
    
    func test_initialState_includesAllFormFields() {
        let (sut, fields) = makeSUT()
        let state = StateSpy(sut.state)
        
        XCTAssertEqual(state.values, [.fields(fields.all)])
    }
        
    func test_ibanFocusedState_includesOnlyIbanField() {
        let (sut, fields) = makeSUT()
        let state = StateSpy(sut.state)

        fields.iban.focus.accept(())

        XCTAssertEqual(state.values, [
            .fields(fields.all),
            .focus(fields.iban, [])
        ])
    }
    
    func test_ibanEditingEnd_showsAllFields() {
        let (sut, fields) = makeSUT()
        let state = StateSpy(sut.state)

        fields.iban.focus.accept(())
        fields.iban.editingDidEnd.accept(())

        XCTAssertEqual(state.values, [
            .fields(fields.all),
            .focus(fields.iban, []),
            .fields(fields.all)
        ])
    }
    
    func test_taxNumberFocusedState_includesOnlyTaxNumberField() {
        let (sut, fields) = makeSUT()
        let state = StateSpy(sut.state)

        fields.taxNumber.focus.accept(())

        XCTAssertEqual(state.values, [
            .fields(fields.all),
            .focus(fields.taxNumber, [])
        ])
    }
    
    func test_taxNumberEditingEnd_showsAllFields() {
        let (sut, fields) = makeSUT()
        let state = StateSpy(sut.state)

        fields.taxNumber.focus.accept(())
        fields.taxNumber.editingDidEnd.accept(())

        XCTAssertEqual(state.values, [
            .fields(fields.all),
            .focus(fields.taxNumber, []),
            .fields(fields.all)
        ])
    }
    
    func test_bankNameFocusedState_doesntChangeState() {
        let (sut, fields) = makeSUT()
        let state = StateSpy(sut.state)

        fields.bankName.focus.accept(())

        XCTAssertEqual(state.values, [.fields(fields.all)])
    }
    
    func test_commentFocusedState_doesntChangeState() {
        let (sut, fields) = makeSUT()
        let state = StateSpy(sut.state)

        fields.comment.focus.accept(())

        XCTAssertEqual(state.values, [.fields(fields.all)])
    }
        
    func test_ibanTextChangeState_providesSuggestionsBasedOnText() {
        let service = SuggestionsServiceStub()
        let (sut, fields) = makeSUT(service: service)
        let state = StateSpy(sut.state)
        
        fields.iban.query.accept(service.stub.query)
        fields.iban.query.accept(service.stub.query)

        XCTAssertEqual(state.values, [
            .fields(fields.all),
            .focus(fields.iban, service.stub.suggestions.map(SuggestionViewModel.init))
        ])
    }
    
    func test_ibanTextChangeToClearState_providesEmptySuggestions() {
        let service = SuggestionsServiceStub()
        let (sut, fields) = makeSUT(service: service)
        let state = StateSpy(sut.state)
        
        fields.iban.query.accept(service.stub.query)
        fields.iban.query.accept(service.stub.query)
        fields.iban.query.accept("")
        
        XCTAssertEqual(state.values, [
            .fields(fields.all),
            .focus(fields.iban, service.stub.suggestions.map(SuggestionViewModel.init)),
            .focus(fields.iban, [])
        ])
    }
    
    func test_TaxNumberTextChangeToClearState_providesEmptySuggestions() {
        let service = SuggestionsServiceStub()
        let (sut, fields) = makeSUT(service: service)
        let state = StateSpy(sut.state)
        
        fields.taxNumber.query.accept(service.stub.query)
        fields.taxNumber.query.accept(service.stub.query)
        fields.taxNumber.query.accept("")
        
        XCTAssertEqual(state.values, [
            .fields(fields.all),
            .focus(fields.taxNumber, service.stub.suggestions.map(SuggestionViewModel.init)),
            .focus(fields.taxNumber, [])
        ])
    }
    
    func test_taxNumberTextChangeState_providesSuggestionsBasedOnText() {
        let service = SuggestionsServiceStub()
        let (sut, fields) = makeSUT(service: service)
        let state = StateSpy(sut.state)
        
        fields.taxNumber.query.accept(service.stub.query)
        fields.taxNumber.query.accept(service.stub.query)

        XCTAssertEqual(state.values, [
            .fields(fields.all),
            .focus(fields.taxNumber, service.stub.suggestions.map(SuggestionViewModel.init))
        ])
    }

    func test_bankNameTextChangeState_doesntChangeState() {
        let (sut, fields) = makeSUT()
        let state = StateSpy(sut.state)
        
        fields.bankName.text.accept("any query")

        XCTAssertEqual(state.values, [.fields(fields.all)])
    }
    
    func test_commentTextChangeState_doesntChangeState() {
        let (sut, fields) = makeSUT()
        let state = StateSpy(sut.state)
        
        fields.comment.text.accept("any query")

        XCTAssertEqual(state.values, [.fields(fields.all)])
    }
    
    func test_ibanSuggestionSelectedState_includesAllFields() throws {
        let service = SuggestionsServiceStub()
        let (sut, fields) = makeSUT(service: service)
        let state = StateSpy(sut.state)
        
        fields.iban.query.accept(service.stub.query)

        let suggestion = try XCTUnwrap(state.values.last?.firstSuggestion, "Expected suggestions in the current state")
        suggestion.select.accept(())
        
        XCTAssertEqual(state.values, [
            .fields(fields.all),
            .focus(fields.iban, service.stub.suggestions.map(SuggestionViewModel.init)),
            .focus(fields.iban, []),
            .fields(fields.all),
        ])
    }
    
    func test_taxNumberSuggestionSelectedState_includesAllFields() throws {
        let service = SuggestionsServiceStub()
        let (sut, fields) = makeSUT(service: service)
        let state = StateSpy(sut.state)
        
        fields.taxNumber.query.accept(service.stub.query)

        let suggestion = try XCTUnwrap(state.values.last?.firstSuggestion, "Expected suggestions in the current state")
        suggestion.select.accept(())
        
        XCTAssertEqual(state.values, [
            .fields(fields.all),
            .focus(fields.taxNumber, service.stub.suggestions.map(SuggestionViewModel.init)),
            .focus(fields.taxNumber, []),
            .fields(fields.all),
        ])
    }

    // MARK: - Helpers

    private func makeSUT(service: SuggestionsServiceStub = .init()) -> (
        sut: PaymentFormViewModel,
        fields: (
            iban: FieldViewModel,
            taxNumber: FieldViewModel,
            bankName: FieldViewModel,
            comment: FieldViewModel,
            all: [FieldViewModel])
    ) {
        let iban = FieldViewModel(title: "IBAN")
        let taxNumber = FieldViewModel(title: "TAX NUMBER")
        let bankName = FieldViewModel(title: "Bank Name")
        let comment = FieldViewModel(title: "Comment")
        let sut = PaymentFormViewModel(iban: iban, taxNumber: taxNumber, bankName: bankName, comment: comment, service: service)
        return (sut, (iban, taxNumber, bankName, comment, [iban, taxNumber, bankName, comment]))
    }

    private class StateSpy {
        private(set) var values: [PaymentFormViewModel.State] = []
        private let disposeBag = DisposeBag()
        
        init(_ observable: Observable<PaymentFormViewModel.State>) {
            observable.subscribe(onNext: { [weak self] state in
                self?.values.append(state)
            }).disposed(by: disposeBag)
        }
    }

}

private extension PaymentFormViewModel.State {
    var firstSuggestion: SuggestionViewModel? {
        switch self {
        case let .focus(_, suggestions):
            return suggestions.first
        default:
            return nil
        }
    }
}
