class InitialTables < ActiveRecord::Migration[5.2]
  def up
    create_table :notation_replacements do |t|
      t.string :to_replace
      t.string :replace_with
      t.integer :execution_order
    end

    create_table :unit_abbreviations do |t|
      t.string :abbreviation
      t.string :unit
      t.integer :execution_order
    end

    create_table :pack_sizes do |t|
      t.string :pack_size
      t.string :description
    end
  end
end
