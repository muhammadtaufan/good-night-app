class CreateTimeEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :time_events do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :event_time
      t.boolean :is_time_in

      t.timestamps
    end
  end
end
