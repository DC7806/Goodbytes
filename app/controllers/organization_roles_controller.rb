class OrganizationRolesController < RolesController
  before_action :find_organization
  before_action :org_admin?, only: [:update, :destroy]
  before_action :pass_acceptor, except: [:new]

  def new
    params_require(:organization_id)
    @command = 'by_org'
    @acceptor_id = @organization_id
    super
  end

  private
  def pass_acceptor
    @acceptor = @organization
  end

end
