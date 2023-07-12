FactoryBot.define do
    factory :tag, class: Tag do
        id { 1 }
        category { "Locomoção" }
        subcategory { "Uber"}
    end
end