# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'agnessa/seed'

account = Account.
  create_with(name: 'test', secret: 'secret', verification_callback_url: 'http://test.test.test', email_from: 'noreply@client.com', form_description: '%{email_from} %{sumdomain} %{name}').
  find_or_create_by!(subdomain: 'test')

user = User.create_with(password: 'test').find_or_create_by!(email: 'test@test.test')

account.members.create_with(role: 'superadmin').
  find_or_create_by!(user: user)

applicant = account.applicants.find_or_create_by!(external_id: 'test')

applicant.verifications.create!({
  name: 'test', last_name: 'test', legacy_external_id: 'test', country: 'ru', document_number: 'test',
  reason: :unban, email: 'test@test.test', status: :pending,
  documents: [Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/image.jpg')), "image/jpeg")]
})

Agnessa::Seed.new.seed_review_result_labels
