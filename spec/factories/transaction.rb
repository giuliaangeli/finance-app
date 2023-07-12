FactoryBot.define do
    factory :transaction_valid_attributes, class: Transaction do
        input_type { "saida" }
        date { "01/04/2023" } 
        value { 300 }
        installments { 1 }
        tag_id { FactoryBot.create(:tag).id }
        user_id { 1 }
    end

    factory :transaction_invalid_attributes, class: Transaction do
        input_type { "saida" }
        date { "01/04/2023" } 
        value { 300 }
        installments { 1 }
        tag_id { 29 }
        user_id { 1 }
    end
end