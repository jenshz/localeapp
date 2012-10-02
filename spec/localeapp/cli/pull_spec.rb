require 'spec_helper'
require 'localeapp/cli/pull'

describe Localeapp::CLI::Pull, "#execute" do
  before do
    @output = StringIO.new
    @puller = Localeapp::CLI::Pull.new(@output)
  end

  it "makes the api call to the translations endpoint" do
    with_configuration do
      @puller.should_receive(:api_call).with(
        :translations,
        :success => :update_backend,
        :failure => :report_failure,
        :max_connection_attempts => 3
      )
      @puller.execute
    end
  end
end

describe Localeapp::CLI::Pull, "#update_backend(response)" do
  before do
    @test_data = ['test data'].to_json
    @output = StringIO.new
    @puller = Localeapp::CLI::Pull.new(@output)
  end

  it "calls the updater" do
    with_configuration do
      Localeapp.poller.stub!(:write_synchronization_data!)
      Localeapp.updater.should_receive(:update).with(['test data'], true)
      @puller.update_backend(@test_data)
    end
  end

  it "writes the synchronization data" do
    with_configuration do
      Localeapp.updater.stub!(:update)
      Localeapp.poller.should_receive(:write_synchronization_data!)
      @puller.update_backend(@test_data)
    end
  end
end
