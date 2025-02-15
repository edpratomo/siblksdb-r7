module Invoiceable
  extend ActiveSupport::Concern

  included do
    has_many :invoices, as: :invoiceable, dependent: :destroy
  end
end
