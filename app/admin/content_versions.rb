ActiveAdmin.register ActiveAdmin::Audit::ContentVersion, as: 'ContentVersion' do
  menu parent: 'System'

  actions :index, :show

  filter :item_type, input_html: { class: 'chosen' }, as: :select
  filter :event, input_html: { class: 'chosen' }, as: :select
  filter :whodunnit, input_html: { class: 'chosen' }, as: :select, collection: -> { Audit.configuration.user_class_name.to_s.classify.constantize.all.map { |u| [u.email, u.id] } }
  filter :created_at

  index do
    id_column
    column :item
    column :item_type
    column :event
    column :who
    column :object_changes do |version|
      version_attributes_diff(version.object_changes)
    end
    column :additional_objects_changes do |version|
      version_attributes_diff(version.additional_objects_changes)
    end
    column :created_at
    actions
  end

  show do |version|
    panel version.item_type do
      attributes_table_for version do
        row :item
        row :item_type
        row :event
        row :who
        row :created_at
      end
    end

    render partial: 'object_changes', locals: {
      event: version.event,
      object_changes: version.object_snapshot_changes,
    }

    render partial: 'additional_objects_changes', locals: {
      event: version.event,
      additional_objects_changes: version.additional_objects_snapshot_changes,
    }

    render partial: 'object_snapshot', locals: {
      object_snapshot: version.object_snapshot,
    }

    render partial: 'additional_objects_snapshot', locals: {
      additional_objects_snapshot: version.additional_objects_snapshot,
    }
  end
end
