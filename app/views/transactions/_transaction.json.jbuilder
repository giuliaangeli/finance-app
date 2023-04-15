json.extract! transaction, :id, :input_type, :date, :value, :installments, :category, :subcategory, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
