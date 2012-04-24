
# class BigIssue < CassandraObject::Base
#   self.column_family = 'Issues'
# 
#   1.upto(400) do |i|
#     string "foo_#{i}"
#   end
# end
# 
# class SmallIssue
#   self.column_family = 'Issues'
# 
#   string :foo
# end
