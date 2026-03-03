class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.references :book, null: false, foreign_key: true
      t.string :email, null: false

      t.timestamps
    end
  end
end
