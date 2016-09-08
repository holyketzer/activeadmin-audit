module TemporaryModelsHelpers
  extend ActiveSupport::Concern

  module TempingComparable
    # For some reason temping objects aren't compared correctly by themselves
    def ==(another)
      self.attributes == another.attributes
    end
  end

  included do
    before do
      Temping.create :movie do
        include ActiveAdmin::Audit::HasVersions

        has_versions also_include: {
          cast_members: [:role, :character_name, :person_id],
          genres: [:id],
          publishing_rule: [:id],
        }

        belongs_to :language
        belongs_to :publishing_rule

        has_many :cast_members
        has_many :genres

        with_columns do |t|
          t.string :name
          t.integer :year
          t.boolean :published
          t.date :release_date
          t.references :language
          t.references :publishing_rule
        end
      end

      Temping.create :genre do
        include TempingComparable

        belongs_to :movie

        with_columns do |t|
          t.references :movie
        end
      end

      Temping.create :cast_member do
        include TempingComparable

        belongs_to :movie
        belongs_to :person

        with_columns do |t|
          t.integer :role
          t.string :character_name
          t.references :movie
          t.references :person
        end
      end

      Temping.create :region do
        include ActiveAdmin::Audit::HasVersions

        has_versions also_include: {
          countries: :country_names,
        }

        def country_names
          countries.map { |code| "Name for #{code}" }
        end

        with_columns do |t|
          t.string :countries, array: true, default: []
        end
      end

      Temping.create :language
      Temping.create :person
      Temping.create :publishing_rule
    end

    after do
      Temping.teardown
    end
  end
end
