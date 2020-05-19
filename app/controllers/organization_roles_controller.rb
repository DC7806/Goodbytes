class OrganizationRolesController < RolesController
  before_action :find_organization
  before_action :org_admin?,      only: [:update, :destroy]
  before_action :pass_model_object

  private
  def pass_model_object
    @model_object = @organization
  end

end
