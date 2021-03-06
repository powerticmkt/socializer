# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Namespace for decorators related to the Person model
  class Person
    # Decorators for {Socializer::Person::Phone}
    class PhoneDecorator < Draper::Decorator
      delegate_all

      # Define presentation-specific methods here. Helpers are accessed through
      # `helpers` (aka `h`). You can override attributes, for example:
      #
      #   def created_at
      #     helpers.tag.span(class: 'time') do
      #       object.created_at.strftime("%a %m/%d/%y")
      #     end
      #   end

      # Returns the formatted label and phone number
      #
      # @example
      #   Mobile : 1112223333
      #
      # @return [String]
      def label_and_number
        content = []
        content << model.label.titleize
        content << " : "
        content << model.number

        helpers.safe_join(content)
      end
    end
  end
end
