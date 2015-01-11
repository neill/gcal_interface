class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :summary
      t.string :description
      t.string :location
      t.datetime :start
      t.datetime :end
      t.integer :owner
      t.string :attendees

      t.timestamps null: false
    end
  end
end
