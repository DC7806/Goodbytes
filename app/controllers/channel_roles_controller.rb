class ChannelRolesController < RolesController
  before_action :find_channel,      except: [:create]
  before_action :channel_admin?,    only:   [:update, :destroy]
  before_action :pass_model_object, except: [:create]

  private
  def pass_model_object
    @model_object = @channel
  end

end
