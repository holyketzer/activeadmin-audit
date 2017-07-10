require 'rails_helper'

RSpec.describe ActiveAdmin::Audit::ContentVersion, temporary_models: true do
  let(:version) { resource.versions.last }

  describe 'resource versioning' do
    describe 'on create' do
      let(:resource) { Movie.new }

      it 'creates version' do
        expect { resource.save! }.to change { resource.versions.count }.by(1)
        expect(version.event).to eq 'create'
      end
    end

    describe 'on update' do
      let(:resource) { Movie.create }

      it 'creates version' do
        resource.release_date = Date.yesterday
        expect { resource.save! }.to change { resource.versions.count }.by(1)
        expect(version.event).to eq 'update'
      end
    end

    describe 'on destroy' do
      let(:resource) { Movie.create }

      it 'creates version' do
        expect { resource.destroy! }.to change { resource.versions.count }.by(1)
        expect(version.event).to eq 'destroy'
      end
    end

    describe 'attributes tracking' do
      let!(:resource) { Movie.create(published: false) }

      attributes = {
        name: 'New name',
        year: 1999,
        published: true,
        language_id: -> { Language.create.id },
      }

      attributes.each do |attr, new_value|
        it "track attribute #{attr}" do
          prev_value = resource.send(attr)
          new_value = new_value.call if new_value.respond_to?(:call)

          resource.update_attributes!(attr => new_value)

          expect(version.object_changes[attr.to_s]).to eq [prev_value, new_value]
        end
      end
    end

    describe 'versioned class renaming' do
      let!(:resource) { Movie.create }

      before do
        # Simulate class renaming
        version.update_attributes!(item_type: 'OldMovieClassName')
      end

      it 'materialization should not fail' do
        expect(version.object_snapshot).to_not be_nil
        expect(version.object_snapshot_changes).to_not be_nil
        expect(version.additional_objects_snapshot).to_not be_nil
        expect(version.additional_objects_snapshot_changes).to_not be_nil
      end
    end
  end

  describe 'resource additional data versioning' do
    shared_examples 'track element adding' do |relation, params = {}|
      has_one = params[:has_one]

      it 'should track element removing' do
        resource.update_attributes!(relation => has_one ? item : [item])

        expect(version.additional_objects[relation.to_s]).to include item_snapshot
        expect(version.additional_objects_changes[relation.to_s]['+']).to include item_snapshot
      end
    end

    shared_examples 'track element removing' do |relation, params = {}|
      has_one = params[:has_one]

      it 'should track element removing' do
        resource.update_attributes!(relation => has_one ? nil : resource.send(relation) - [item])

        expect(version.additional_objects[relation.to_s]).to_not include item_snapshot
        expect(version.additional_objects_changes[relation.to_s]['-']).to include item_snapshot
      end
    end

    describe 'has_many relation by id' do
      let(:item) { Genre.create }
      let(:item_snapshot) do
        { 'id' => item.id }
      end

      describe 'add genres' do
        let!(:resource) { Movie.create }

        it_behaves_like 'track element adding', :genres
      end

      describe 'remove genre' do
        let!(:resource) { Movie.create(genres: [item]) }

        it_behaves_like 'track element removing', :genres
      end
    end

    describe 'has_many relation with attributes' do
      let(:person) { Person.create }
      let(:item) { CastMember.create(person: person) }
      let(:item_snapshot) do
        {
          'role' => item.role,
          'character_name' => item.character_name,
          'person_id' => item.person_id,
        }
      end

      describe 'add cast member' do
        let!(:resource) { Movie.create }

        it_behaves_like 'track element adding', :cast_members
      end

      describe 'remove cast member' do
        let!(:resource) { Movie.create(cast_members: [item]) }

        it_behaves_like 'track element removing', :cast_members
      end
    end

    describe 'has_one relation by id' do
      let(:item) { PublishingRule.create }
      let(:item_snapshot) do
        { 'id' => item.id }
      end

      describe 'add publishing rule' do
        let!(:resource) { Movie.create(published: false) }

        it_behaves_like 'track element adding', :publishing_rule, has_one: true
      end

      describe 'remove publishing rule' do
        let!(:resource) { Movie.create(published: false, publishing_rule: item) }

        it_behaves_like 'track element removing', :publishing_rule, has_one: true
      end
    end

    describe 'any data defined by method' do
      let(:item) { 'RU' }
      let(:item_snapshot) { 'Name for RU' }

      describe 'add country' do
        let!(:resource) { Region.create }

        it_behaves_like 'track element adding', :countries
      end

      describe 'remove country' do
        let!(:resource) { Region.create(countries: [item, 'GB']) }

        it_behaves_like 'track element removing', :countries
      end
    end
  end
end
