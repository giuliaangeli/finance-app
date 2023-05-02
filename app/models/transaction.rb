class Transaction < ApplicationRecord
    belongs_to :user, optional: false
    has_one :tag
    validates :input_type, :date, :value, :installments, :user, presence:true
end
