class Transaction < ApplicationRecord
    validates :input_type, :date, :value, :installments, :category, :subcategory, presence:true
end
