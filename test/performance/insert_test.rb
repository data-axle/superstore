
# class BigIssue < CassandraObject::Base
#   key :uuid
#   self.column_family = 'Issues'
# 
#   1.upto(400) do |i|
#     string "foo_#{i}"
#   end
# end
# 
# class SmallIssue
#   key :uuid
#   self.column_family = 'Issues'
# 
#   string :foo
# end
