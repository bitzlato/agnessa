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
  find_or_create_by!(subdomain: 'bz')

user = User.create_with(password: 'test').find_or_create_by!(email: 'test@test.test')

account.members.create_with(role: 'admin').
  find_or_create_by!(user: user)

applicant = account.applicants.find_or_create_by!(external_id: 'test')

CountrySeed.new.call

verification = applicant.verifications.build({
  name: 'test', last_name: 'test', birth_date: '01-01-1991', gender: :male, legacy_external_id: 'test', document_type: 'passport', citizenship_country_iso_code: 'RU', document_number: 'test',
  reason: :unban, email: 'test@test.test', status: :pending
})

account.document_types.alive.each do |document_type|
  if document_type.file_type == 'video'
    verification.verification_documents.new document_type: document_type, file: File.open(File.join(Rails.root, '/spec/fixtures/video.mp4'))
  else
    verification.verification_documents.new document_type: document_type, file: File.open(File.join(Rails.root, '/spec/fixtures/image.jpg'))
  end
end
verification.save!

Agnessa::Seed.new.seed_review_result_labels
