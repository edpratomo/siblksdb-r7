require 'rails_helper'

RSpec.describe UpdateInvoiceJob, type: :job do
  subject(:job) { described_class.perform_later(key) }

  let(:key) { "BookUniformFee" }

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
      .with(key)
      .on_queue("default")
  end
end
