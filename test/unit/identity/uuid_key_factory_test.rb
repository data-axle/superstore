require 'test_helper'

class CassandraObject::Identity::UuidKeyFactoryTest < CassandraObject::TestCase
  test 'parse' do
    assert_not_nil key_factory.parse('95b2cf70-c318-11e0-962b-0800200c9a66')
    assert_nil key_factory.parse('xyz')
    assert_nil key_factory.parse(nil)
  end

  private
    def key_factory
      @key_factory ||= CassandraObject::Identity::UUIDKeyFactory.new
    end
end