def get_model(model_name)
  klass = Object.const_get(model_name)
  if klass.superclass.name == "ApplicationRecord"
    return klass
  else
    raise NameError, "#{model_name} isn't a Rails model. -by Koten"
  end
end

def uniq_methods(target)
  target.methods.sort.select{|x|puts x unless Object.methods.include? x}
end