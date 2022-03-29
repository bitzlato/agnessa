module Agnessa
  class Seed
    def initialize
      @result = []
    end

    def seeds
      YAML.safe_load(
        ERB.new(
          File.read(
            Rails.root.join 'config', 'seeds.yml'
          )
        ).result
      )
    end

    def logger
      @logger ||= Logger.new(STDERR, progname: "db:seed")
    end

    def seed_clients
      Client.create!(name: 'test', subdomain: 'test', secret: 'secret', verification_callback_url: 'http://test.test.test')
    end

    def seed_client_users
      Client.first.client_users.create!(login: 'test', password: 'test', role: 'superadmin')
    end

    def seed_applicants
      Client.first.applicants.create!(external_id: 'test')
    end

    def seed_verifications
      Applicant.last.verifications.create({
        name: 'test', last_name: 'test', legacy_verification_id: 'test', country: 'ru', passport_data: 'test',
        reason: :unban, email: 'test@test.test', status: :init,
        documents: [Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/image.jpg')))]
      })
    end

    def seed_review_result_labels
      logger.info "Seeding labels"

      seeds["review_result_labels"].each_with_index do |label, index|
        logger.info "---"
        if ReviewResultLabel.find_by(label: label["label"]).present?
          logger.info "Label '#{label['label']} already exists"
          next
        end
        ReviewResultLabel.create!(label: label['label'], final: label['final'], label_ru: label['label_ru'], description: label['description'] )
      end

    end
  end
end
