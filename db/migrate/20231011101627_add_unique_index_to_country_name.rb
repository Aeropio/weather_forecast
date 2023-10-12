class AddUniqueIndexToCountryName < ActiveRecord::Migration[6.1]
  def change
    add_index :countries, :name, unique: true
  end
end
