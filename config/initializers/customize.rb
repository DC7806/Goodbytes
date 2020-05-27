class String
  def limit(max_length)
    length > max_length ? self[0..max_length - 1] + '...' : self
  end

  def line_break(line_width)
    scan(/.{1,#{line_width}}/).join("\n")
  end
end

# 給定model名string，可找到model class本體
def get_model(model_name)
  klass = Object.const_get(model_name)
  if klass.superclass.name == "ApplicationRecord"
    return klass
  else
    raise NameError, "#{model_name} isn't a Rails model."
  end
end

# rails console使用，可找物件獨有方法
def uniq_methods(target)
  target.methods.sort.select{|x|puts x unless Object.methods.include? x}
end

# 命名慣例全站統一，未來想改可直接改這邊
def admin
  'admin'
end

def member
  'member'
end

