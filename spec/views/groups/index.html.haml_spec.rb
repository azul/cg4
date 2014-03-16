require "spec_helper"

describe "groups/index.html.haml" do
  before do
    Rails.cache.clear
  end
  it "caches groups based on visibility" do
    ActionController::Base.perform_caching = true
    assign(:groups, [
      stub_model(Group, name: "dicer", visibility: 'visible_to_user')
    ])
    view.stub(:current_user).and_return(nil)
    render
    rendered.should include("dicer")
    rendered.should_not include("Show")

    view.stub(:current_user).and_return(User.new)
    render

    rendered.should include("dicer")
    rendered.should include("Show")
  end
end
