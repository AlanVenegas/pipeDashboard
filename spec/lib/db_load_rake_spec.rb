require 'rails_helper'
require 'rake'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :fakeweb
end


describe "p2d:populate_users" do

  before do
    User.delete_all
    load "lib/tasks/db_load.rake"
    Rake::Task.define_task(:environment)
  end

  it "loads users" do
    VCR.use_cassette('synopsis') do
      Rake::Task["p2d:populate_users"].invoke
      expect(User.count).to be == 2
    end
  end

end


=begin
describe "reports:users" do
  include_context "rake"

  let(:csv)          { stub("csv data") }
  let(:report)       { stub("generated report", :to_csv => csv) }
  let(:user_records) { stub("user records for report") }

  before do
    ReportGenerator.stubs(:generate)
    UsersReport.stubs(:new => report)
    User.stubs(:all => user_records)
  end

  its(:prerequisites) { should include("environment") }

  it "generates a registrations report" do
    subject.invoke
    ReportGenerator.should have_received(:generate).with("users", csv)
  end

  it "creates the users report with the correct data" do
    subject.invoke
    UsersReport.should have_received(:new).with(user_records)
  end
end

describe "reports:purchases" do
  include_context "rake"

  let(:csv)              { stub("csv data") }
  let(:report)           { stub("generated report", :to_csv => csv) }
  let(:purchase_records) { stub("purchase records for report") }

  before do
    ReportGenerator.stubs(:generate)
    PurchasesReport.stubs(:new => report)
    Purchase.stubs(:valid => purchase_records)
  end

  its(:prerequisites) { should include("environment") }

  it "generates an purchases report" do
    subject.invoke
    ReportGenerator.should have_received(:generate).with("purchases", csv)
  end

  it "creates the purchase report with the correct data" do
    subject.invoke
    PurchasesReport.should have_received(:new).with(purchase_records)
  end
end

describe "reports:all" do
  include_context "rake"

  its(:prerequisites) { should include("users") }
  its(:prerequisites) { should include("purchases") }
end
=end
