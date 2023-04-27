require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  test 'rejected status' do
    invoice = invoices(:one)

    #is the invoice in created status?
    assert invoice.created?

    #the invoice can be rejected from the 'created' status
    invoice.rejected!
    assert invoice.rejected?

    #an invoice cannot be transitioned from 'rejected' back to 'created'
    assert_raises ActiveRecord::RecordInvalid do
      invoice.created!
    end
  end

  test 'sequential change status' do
    invoice = invoices(:one)

    #is the invoice in created status?
    assert invoice.created?  

    # status can be changed from created to approved
    invoice.approved!
    assert invoice.approved?

    # status can be changed from approved to purchased
    invoice.purchased!
    assert invoice.purchased?

    # once purchased, purchase_date is set
    assert !invoice.purchase_date.nil?

    # status can be changed from purchased to closed
    invoice.closed!
    assert invoice.closed?

    #the status can't be moved from 'closed'
    assert_raises ActiveRecord::RecordInvalid do
      invoice.purchased!
    end
  end

  test 'skip statuses' do
    invoice = invoices(:one)

    # status can be moved directly to purchased
    invoice.purchased!
    assert invoice.purchased?

    # status can be moved directly to closed
    invoice.closed!
    assert invoice.closed?
  end

  test 'reverse statuses' do
    invoice = invoices(:one)

    # status can't be moved from 'approved' back to 'created'
    invoice.approved!
    assert_raises ActiveRecord::RecordInvalid do
      invoice.created!
    end

    # status can't be moved from 'purchased' back to 'approved'
    invoice.purchased!
    assert_raises ActiveRecord::RecordInvalid do
      invoice.approved!
    end
  end
end
