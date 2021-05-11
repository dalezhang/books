require 'rails_helper'
describe BooksService  do
  let(:user) { create :user }
  let(:book) { create :book }
  describe 'books service' do
    context 'borrow book' do
      it 'should decrease book count and create a BooksTransaction' do
        origin_count = book.count
        service = BooksService.new
        books_transaction = service.borrow(user.id, book.id)
        book.reload
        user.reload

        expect(origin_count - book.count).to eq(1)
        expect(user.freeze_amount).to eq(BooksService::COST)
        expect(books_transaction.status).to eq("no_returned")
        expect(books_transaction.option).to eq("out")
        expect(books_transaction.user_id).to eq(user.id)
        expect(books_transaction.to_count).to eq(book.count)
      end
    end
    context 'return book' do
      it 'should increase book count and create a BooksTransaction and a UserAmountTransaction' do
        origin_amount = user.amount
        service = BooksService.new
        parent_books_transaction = service.borrow(user.id, book.id)
        book.reload
        origin_count = book.count

        service = BooksService.new
        return_books_transaction = service.return(user.id, book.id)
        book.reload
        user.reload
        parent_books_transaction.reload
        expect(book.count - origin_count).to eq(1)
        expect(book.total_income).to eq(BooksService::COST)
        expect(origin_amount - user.amount).to eq(BooksService::COST)
        expect(book.books_transactions.count).to eq(2)
        expect(parent_books_transaction.status).to eq("returned")
        expect(return_books_transaction.status).to eq("returned")
        expect(return_books_transaction.option).to eq("back")
        expect(return_books_transaction.parent_id).to eq(parent_books_transaction.id)
        expect(return_books_transaction.to_count).to eq(book.count)
        expect(return_books_transaction.from_count).to eq(parent_books_transaction.to_count)
        user_amount_transactions = user.user_amount_transactions
        expect(user_amount_transactions.count).to eq(1)
        expect(user_amount_transactions.first.to_amount).to eq(user.amount)

      end
    end

  end
end
