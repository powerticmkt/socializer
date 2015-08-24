#
# Namespace for the Socializer engine
#
module Socializer
  # Namespace for models related to the Person model
  class Person
    #
    # Person Education model
    #
    # Where the {Socializer::Person person} has gone to school
    #
    class Education < ActiveRecord::Base
      attr_accessible :school_name, :major_or_field_of_study, :started_on,
                      :ended_on, :current, :courses_description

      # Relationships
      belongs_to :person

      # Validations
      validates :person, presence: true
      validates :school_name, presence: true
      validates :started_on, presence: true
    end
  end
end