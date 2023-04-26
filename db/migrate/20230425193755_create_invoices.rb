class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.text :body, null: false
      t.integer :status, default: 0
      t.string :invoice_number, null: false
      t.integer :invoice_amount_cents, default: 0, null: false
      t.string :file_url, null: false
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
