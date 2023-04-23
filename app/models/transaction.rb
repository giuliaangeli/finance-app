class Transaction < ApplicationRecord
    belongs_to :user, optional: false
    validates :input_type, :date, :value, :installments, :category, :subcategory, :user, presence:true
end
