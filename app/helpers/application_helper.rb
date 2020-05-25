module ApplicationHelper
  def filted_attributes(model_object)
    result = {}
    no_need_params = [
      "created_at",
      "updated_at",
      "deleted_at"
    ]
    model_object.attributes.each do |key, value|
      if !no_need_params.include?(key) && value
        result[key] = value
      end
    end

    return result
  end
end
