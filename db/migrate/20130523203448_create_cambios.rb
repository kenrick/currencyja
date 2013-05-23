class CreateCambios < ActiveRecord::Migration
  def up
    create_table :cambios do |t|
      t.string :name
      t.text :currencies
      t.timestamps
    end
  end

  def down
    drop_table :cambios
  end
end
