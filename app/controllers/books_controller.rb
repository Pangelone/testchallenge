class BooksController < ApplicationController
    before_action :set_book only: [:show, :reserve]

    def index
        @books = Book.select(:id, :title, :status).limit(limit_param).offset(offset_param)(offset_param)
        render json: @books
    end

    def show
        render json: @book
    end

    def reserve
        email = params[:email].to_s.strip
        return render json: { error: 'Email is required' }, status: :unprocessable_entity if email.blank?

        if @book.reserved || @book.checked_out
            return render json: { error: 'Book is not available' }, status: :unprocessable_entity
        end

        Reservation.transaction do
            @book.lock!
            reservarion = @book.reservations.create!(email: email)
            @book.update!(status: :reserved)

            render json: { 
                book_id: @book.id,
                reservation_id: reservation.id,
                status: @book.status
            }, status: :created
        end
    end

    private

    def book_params
        @book = Book.find(params[:id])
    end

    def limit_param
        params.fetch(:limit, 20).to_i
    end

    def offset_param
        params.fetch(:offset, 0).to_i
    end
end