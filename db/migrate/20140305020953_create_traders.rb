class CreateTraders < ActiveRecord::Migration
  def up
    create_table :traders do |t|
      t.string :name
      t.string :short_name
      t.timestamps
    end
  end

  def down
    drop_table :traders
  end
end
