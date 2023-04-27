require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  test 'can create new client' do
    client = clients(:one)
    invoice1 = invoices(:one)
    invoice2 = invoices(:two)

    # client has name 
    assert client.name?
  end
end
