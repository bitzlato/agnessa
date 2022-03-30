# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'agnessa/seed'

client = Client.
  create_with(name: 'test', secret: 'secret', verification_callback_url: 'http://test.test.test', email_from: 'noreply@client.com').
  find_or_create_by!(subdomain: 'test')

client.client_users.create_with(login: 'test', password: 'test', role: 'superadmin').
  find_or_create_by!(login: 'test')

applicant = client.applicants.find_or_create_by!(external_id: 'test')

applicant.verifications.create({
  name: 'test', last_name: 'test', legacy_verification_id: 'test', country: 'ru', passport_data: 'test',
  reason: :unban, email: 'test@test.test', status: :init,
  documents: [Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/image.jpg')))]
})

Agnessa::Seed.new.seed_review_result_labels
