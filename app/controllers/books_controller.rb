class BooksController < ApplicationController
  before_action :set_book, only: %i[show reserve]

  def index
    books = Book.select(:id, :title, :status)
                .order(:id)
                .limit(limit_param)
                .offset(offset_param)
    render json: books
  end

  def show
    render json: @book
  end

  def reserve
    email = params[:email].to_s.strip
    return render json: { error: 'Email is required' }, status: :unprocessable_entity if email.blank?

    Reservation.transaction do
      @book.lock!
      # Status guard for reserved/checked_out books
      if @book.reserved? || @book.checked_out?
        render json: { error: 'Book is not available' }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end

      reservation = @book.reservations.create!(email: email)
      @book.update!(status: :reserved)

      render json: {
        book_id: @book.id,
        reservation_id: reservation.id,
        status: @book.status
      }, status: :created
    end
  end

  private

  def set_book
    @book = Book.select(:id, :title, :author, :status).find(params[:id])
  end

  def limit_param
    limit = params.fetch(:limit, 20).to_i
    limit.clamp(1, 100)
  end

  def offset_param
    offset = params.fetch(:offset, 0).to_i
    offset.negative? ? 0 : offset
  end
end