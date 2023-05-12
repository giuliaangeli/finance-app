class Tag < ApplicationRecord
    has_many :my_transaction, class_name: "Transaction", foreign_key: "id"
end
