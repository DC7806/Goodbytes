class ChannelRolesController < RolesController
  before_action :find_channel
  before_action :channel_admin?,  only: [:update, :destroy]
  before_action :pass_model_object

  private
  def pass_model_object
    @model_object = @channel
  end

end
