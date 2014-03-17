require "spec_helper"

describe "groups/index.html.haml" do
  before do
    Rails.cache.clear
  end
  it "caches groups based on visibility" do
    ActionController::Base.perform_caching = true
    allow(view).to receive(:policy).and_return double(show?: false)
    assign(:groups, [
      stub_model(Group, name: "dicer", visibility: 'visible_to_user')
    ])
    render
    rendered.should include("dicer")
    rendered.should_not include("Show")

    assign(:groups, [
      stub_model(Group, name: "dicer", visibility: 'visible_to_user', relationship_to: :member)
    ])
    allow(view).to receive(:policy).
      and_return double(show?: true, edit?: false, destroy?: false)
    render

    rendered.should include("dicer")
    rendered.should include("Show")
  end

  it "displays new group link for users" do
    assign(:groups, [])
    sign_in FactoryGirl.create :user
    render
    expect(rendered).to include("New Group")
  end

  it "hides new group link from visitors" do
    assign(:groups, [])
    render
    expect(rendered).to_not include("New Group")
  end

end
