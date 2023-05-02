# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Tag.destroy_all

Tag.create!([
    { category: "Alimentação", subcategory: "Delivery"},
    { category: "Alimentação", subcategory: "Mercado"},
    { category: "Alimentação", subcategory: "Padaria"},
    { category: "Alimentação", subcategory: "Outros"},
    { category: "Locomoção", subcategory: "Uber"},
    { category: "Locomoção", subcategory: "Transporte Público"},
])

p "Created Tags"