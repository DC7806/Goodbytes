class ChannelRolesController < RolesController
  before_action :find_channel
  before_action :channel_admin?,  only: [:update, :destroy]
  before_action :pass_acceptor, except: [:new]

  def new
    params_require(:channel_id)
    @command     = 'by_channel'
    @acceptor_id = @channel_id
    super
  end

  private
  def pass_acceptor
    @acceptor = @channel
  end

end
