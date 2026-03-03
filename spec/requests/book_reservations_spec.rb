require 'rails_helper'

RSpec.describe 'Book reservations', type: :request do
  describe 'POST /books/:id/reserve' do
    it 'creates a reservation and marks the book as reserved' do
      book = Book.create!(title: 'Dune', author: 'Frank Herbert', status: :available)

      expect {
        post "/books/#{book.id}/reserve", params: { email: 'user@example.com' }
      }.to change(Reservation, :count).by(1)

      expect(response).to have_http_status(:created)
      book.reload
      expect(book.status).to eq('reserved')
    end

    it 'rejects when email is missing' do
      book = Book.create!(title: 'Dune', author: 'Frank Herbert', status: :available)

      post "/books/#{book.id}/reserve", params: { email: ' ' }

      expect(response).to have_http_status(:unprocessable_entity)
      book.reload
      expect(book.status).to eq('available')
    end

    it 'rejects when book is already reserved' do
      book = Book.create!(title: 'Dune', author: 'Frank Herbert', status: :reserved)

      post "/books/#{book.id}/reserve", params: { email: 'user@example.com' }

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'rejects when book is checked out' do
      book = Book.create!(title: 'Dune', author: 'Frank Herbert', status: :checked_out)

      post "/books/#{book.id}/reserve", params: { email: 'user@example.com' }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
