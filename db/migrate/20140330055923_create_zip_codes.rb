class CreateZipCodes < ActiveRecord::Migration
  def change
    create_table :zip_codes do |t|
      t.string :code
      t.index :code, :unique => true
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
