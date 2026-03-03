class CreateReservations < ActiveRecord::Migration[7.5]
    def change
        create_table :reservations do |t|
            t.belongs_to :book, null: false, foreign_key: true
            t.string :email, null: false

            t.timestamps
        end
    end
end