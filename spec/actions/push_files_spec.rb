require 'spec_helper'

describe TeachersPet::Actions::PushFiles do
  include InteractiveHelpers

  let(:action) { TeachersPet::Actions::PushFiles.new }

  it "runs" do
    respond("What repository name should pushed to for each student?", 'assignment')
    respond("What is the organization name?", 'testorg')
    respond("What is the filename of the list of students?", students_list_fixture_path)
    respond("What is the ssh endpoint?", 'github.com')
    stub_github_config

    request_stubs = []
    request_stubs << stub_get_json('https://testteacher:abc123@api.github.com/orgs/testorg',
      login: 'testorg',
      name: 'Test Org',
      url: 'http://test.org'
    )
    request_stubs << stub_get_json('https://testteacher:abc123@api.github.com/orgs/testorg/teams?per_page=100', [
      {
        name: 'teststudent'
      }
    ])

    action.run

    request_stubs.each do |request_stub|
      expect(request_stub).to have_been_requested.once
    end
  end
end
