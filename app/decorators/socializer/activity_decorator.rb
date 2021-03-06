# frozen_string_literal: true

#
# Namespace for the Socializer engine
#
module Socializer
  # Decorators for {Socializer::Activity}
  class ActivityDecorator < ApplicationDecorator
    # TODO: ActivityDecorator - be explicit about what is delegated
    delegate_all

    # Define presentation-specific methods here. Helpers are accessed through
    # `helpers` (aka `h`). You can override attributes, for example:
    #
    #   def created_at
    #     helpers.tag.span(class: 'time') do
    #       object.created_at.strftime("%a %m/%d/%y")
    #     end
    #   end
  end
end
