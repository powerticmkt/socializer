require 'digest/md5'

module Socializer
  class Person < ActiveRecord::Base
    include Socializer::EmbeddedObjectBase
    
    has_many :authentications
    
    attr_accessible :display_name, :email, :language, :avatar_provider
    
    validates_inclusion_of :avatar_provider, :in => %w( TWITTER FACEBOOK LINKEDIN GRAVATAR )
    
    def circles
      @circles ||= embedded_object.circles
    end
    
    def comments
      @comments ||= embedded_object.comments
    end
    
    def notes
      @notes ||= embedded_object.notes
    end
    
    def groups
      @groups ||= embedded_object.groups
    end
    
    def memberships
      @memberships ||= embedded_object.memberships
    end
    
    def received_notifications
      raise "Method not implemented yet."
    end
    
    def contacts
      @contacts ||= self.circles.map { |c| c.contacts }.flatten.uniq
    end
    
    def contact_of
      @contact_of ||= Circle.joins(:ties).where('socializer_ties.contact_id' => self.guid).map { |circle| circle.author }.uniq
    end

    def likes
      @likes ||= Activity.where(:actor_id => self.embedded_object.id, :verb => 'like', :parent_id => nil).delete_if { |activity| 
        (Activity.where(:actor_id => self.embedded_object.id, :verb => 'unlike', :parent_id => nil).map { |activity| activity.object.guid }).include?(activity.object.guid) 
      }
    end
    
    def likes? (object)
      likes = Activity.where(:object_id => object.id, :actor_id => self.embedded_object.id, :verb => 'like')
      if likes.count == 0
        return false
      else
        unlikes = Activity.where(:object_id => object.id, :actor_id => self.embedded_object.id, :verb => 'unlike')
        if likes.count == unlikes.count
          return false
        end
      end
      return true
    end
    
    def pending_memberships_invites
      @pending_memberships_invites ||= memberships.where(:active => false).where(" ( SELECT COUNT(1) FROM socializer_groups WHERE socializer_groups.id = socializer_memberships.group_id AND socializer_groups.privacy_level = 'PRIVATE' ) > 0 ")
    end
    
    def avatar_url
      if avatar_provider == "FACEBOOK"
        authentications.where(:provider => 'facebook')[0].image_url unless authentications.where(:provider => 'facebook')[0].nil?
      elsif avatar_provider == "TWITTER"
        authentications.where(:provider => 'twitter')[0].image_url unless authentications.where(:provider => 'twitter')[0].nil?
      elsif avatar_provider == "LINKEDIN"
        authentications.where(:provider => 'linked_in')[0].image_url unless authentications.where(:provider => 'linked_in')[0].nil?
      else
        "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(self.email.downcase)}" unless self.email.nil?
      end
    end
    
    def self.create_with_omniauth(auth)
      image_url = ""
      create! do |user|
        if auth['user_info']
          user.display_name = auth['user_info']['name'] if auth['user_info']['name']
          user.email = auth['user_info']['email'] if auth['user_info']['email']
          image_url = auth['user_info']['image'] if auth['user_info']['image']
        end
        if auth['extra'] && auth['extra']['user_hash']
          user.display_name = auth['extra']['user_hash']['name'] if auth['extra']['user_hash']['name']
          user.email = auth['extra']['user_hash']['email'] if auth['extra']['user_hash']['email']
          image_url = auth['extra']['user_hash']['image'] if auth['extra']['user_hash']['image']
        end
        user.avatar_provider = "GRAVATAR"
        user.authentications.build(:provider => auth['provider'], :uid => auth['uid'], :image_url => image_url)
      end
    end
    
  end
end
