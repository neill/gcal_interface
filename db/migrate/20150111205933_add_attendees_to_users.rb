class AddAttendeesToUsers < ActiveRecord::Migration
  def change
    add_column :events, :attendees, :string
  end
end
