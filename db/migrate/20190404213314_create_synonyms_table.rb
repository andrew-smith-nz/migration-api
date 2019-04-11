class CreateSynonymsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :synonyms do |t|
      t.string :word
      t.string :synonym
    end
  end
end
