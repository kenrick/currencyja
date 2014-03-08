class CreateCurrencies < ActiveRecord::Migration
  def up
    create_table :currencies do |t|
      t.string  :note
      t.decimal :buy_cash,    presicion: 8, scale: 2
      t.decimal :buy_draft,   presicion: 8, scale: 2
      t.decimal :sell_cash,   presicion: 8, scale: 2
      t.decimal :sell_draft,  presicion: 8, scale: 2
      t.references :trader
      t.timestamps
    end
  end

  def down
    drop_table :currencies
  end
end
