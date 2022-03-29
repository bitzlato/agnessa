# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



seed = Agnessa::Seed.new

seed.seed_clients
seed.seed_client_users
seed.seed_applicants
seed.seed_verifications
seed.seed_review_result_labels