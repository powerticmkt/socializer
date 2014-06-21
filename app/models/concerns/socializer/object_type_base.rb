module Socializer
  module ObjectTypeBase
    extend ActiveSupport::Concern

    included do
      attr_accessor   :activity_verb, :privacy, :object_ids, :activity_target_id
      attr_accessible :activity_verb, :privacy, :object_ids, :author_id, :activity_target_id

      has_one :activity_object, as: :activitable, dependent: :destroy

      before_create :activity_object_builder
      after_create  :append_to_activity_stream
    end

    module ClassMethods
      def guids
        # FIXME: Rails 4.2 - https://github.com/rails/rails/pull/13555 - Allows using relation name when querying joins/includes
        # joins(:activity_object).select(activity_object: :id)
        joins(:activity_object).select('socializer_activity_objects.id')
      end
    end

    def guid
      activity_object.id
    end

    protected

    # REFACTOR: remove the before_create callback. Move the callback to the controller(s)?
    #           Create a Collaborating Object?
    def activity_object_builder
      build_activity_object
    end

    # REFACTOR: remove the after_create callback. Move the callback to the controller(s)?
    #           Create a Collaborating Object
    def append_to_activity_stream
      # the `return if activity_verb.blank?` guard is needed to block the create! method when
      # creating shares, likes, unlikes, etc
      return if activity_verb.blank?

      ActivityCreator.create!(actor_id: author_id,
                              activity_object_id: guid,
                              target_id: activity_target_id,
                              verb: activity_verb,
                              object_ids: object_ids)
    end
  end
end
