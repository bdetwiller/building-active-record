require 'active_record_lite'

class MyMassObject < MassObject
  set_attrs(:x, :y)
end
p MyMassObject.attributes
obj = MyMassObject.new(:x => :x_val, :y => :y_val)
p obj
