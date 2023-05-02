class Tag < ApplicationRecord
    belongs_to :my_transaction, class_name: "Transaction", foreign_key: "transaction_id"
end
