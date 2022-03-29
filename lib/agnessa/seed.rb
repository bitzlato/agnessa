module Agnessa
  class Seed
    def initialize
      @result = []
    end

    def seeds
      YAML.safe_load(
        ERB.new(
          File.read(
            Rails.root.join 'config', 'review_result_labels.yml'
          )
        ).result
      )
    end

    def logger
      @logger ||= Logger.new(STDERR, progname: "db:seed")
    end

    def seed_review_result_labels
      logger.info "Seeding labels"

      seeds["review_result_labels"].each_with_index do |label, index|
        if ReviewResultLabel.find_by(label: label["label"]).present?
          logger.info "Label '#{label['label']} already exists"
          next
        end
        ReviewResultLabel.create!(label: label['label'], final: label['final'], label_ru: label['label_ru'], description: label['description'] )
      end

    end
  end
end
