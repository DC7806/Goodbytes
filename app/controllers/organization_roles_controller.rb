class OrganizationRolesController < RolesController
  before_action :find_organization, except: [:create]
  before_action :org_admin?,        only:   [:update, :destroy]
  before_action :pass_model_object, except: [:create]

  private
  def pass_model_object
    @model_object = @organization
  end

end
