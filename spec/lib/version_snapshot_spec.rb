require 'rails_helper'

RSpec.describe ActiveAdmin::Audit::VersionSnapshot, temporary_models: true do
  describe '#materialize' do
    shared_examples 'materializator' do
      it { expect(described_class[snapshot].materialize(klass)).to eq result }
    end

    context 'for Movie' do
      let(:klass) { Movie }

      describe 'ignore plain values' do
        let(:snapshot) do
          {
            'id' => 1,
            'name' => 'My movie',
          }
        end

        let(:result) { snapshot }

        it_behaves_like 'materializator'
      end

      describe 'ignores plain arrays' do
        let(:snapshot) do
          { 'region_values' => ['Russia', 'Western Europe', 'Southeastern Europe', 'Northern Europe'] }
        end

        let(:result) { snapshot }

        it_behaves_like 'materializator'
      end

      describe 'materialize belongs_to relations' do
        let(:language) { Language.create }

        let(:snapshot) do
          { 'language_id' => language.id }
        end

        let(:result) do
          { 'language_id' => language }
        end

        it_behaves_like 'materializator'
      end

      describe 'materialize active record items by ids' do
        context 'existing record' do
          let(:genre) { Genre.create }

          let(:snapshot) do
            { 'genres' => [{ 'id' => genre.id }] }
          end

          let(:result) do
            { 'genres' => [genre] }
          end

          it_behaves_like 'materializator'
        end

        context 'removed record' do
          let(:genre) { Genre.create }

          let!(:snapshot) do
            { 'genres' => [{ 'id' => genre.id }] }
          end

          let!(:result) do
            { 'genres' => ["Genre ##{genre.id} was removed"] }
          end

          before { genre.destroy! }

          it_behaves_like 'materializator'
        end
      end

      describe 'materialize active record items inside nested items' do
        let(:movie) { Movie.create }
        let(:person) { Person.create }
        let(:cast_member) { CastMember.create(movie: movie, person: person) }

        let(:snapshot) do
          {
            'cast_members' => [
              {
                'role' => cast_member.role,
                'character_name' => cast_member.character_name,
                'person_id' => cast_member.person_id,
              },
            ],
          }
        end

        let(:result) do
          {
            'cast_members' => [
              {
                'role' => cast_member.role,
                'character_name' => cast_member.character_name,
                'person_id' => person,
              },
            ],
          }
        end

        it_behaves_like 'materializator'
      end

      describe 'materialize diff' do
        let(:old_genre) { Genre.create }
        let(:new_genre) { Genre.create }

        let(:snapshot) do
          {
            'genres' => {
              '-' => [{ 'id' => old_genre.id }],
              '+' => [{ 'id' => new_genre.id }],
            },
          }
        end

        let(:result) do
          {
            'genres' => {
              '-' => [old_genre],
              '+' => [new_genre],
            },
          }
        end

        it_behaves_like 'materializator'
      end
    end
  end
end