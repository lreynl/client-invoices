class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.text :body, null: false
      t.string :status, default: 0, null: false
      t.string :uuid, null: false
      t.string :file_url, null: false
      # t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
