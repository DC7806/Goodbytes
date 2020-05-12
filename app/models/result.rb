class Result
  def initialize(hash)

   hash.each do |k,v|
     name = k.to_s.gsub(/\W+/,'')
     instance_variable_set('@'+name, v)
     define_singleton_method(name+'=') do |x|
       instance_variable_set '@'+name, x
     end
     define_singleton_method(name) do
       instance_variable_get '@'+name
     end
   end

 end
end