require 'spec_helper'

RSpec.describe Issue, :type => :model do

  fixtures :responses, :issues, :trackers, :issue_statuses, :enabled_modules,
           :projects, :enumerations, :users, :roles, :members, :member_roles

  let!(:response) { Response.find(1) }
  let!(:response_without_final_status) { Response.find(2) }
  let!(:issue_7) { Issue.find(7) }

  before do
    User.current = User.find(2)
  end

  context "issue available responses" do
    it "returns an empty array if user cannot update the issue" do
      User.current = User.anonymous
      expect(issue_7.available_responses).to be_empty
    end

    it "returns an array of responses" do
      expect(issue_7.available_responses.size).to eq 2
    end

    it "does not return responses if current status does not match configured status in rules" do
      issue_7.update(status_id: 5) # Close issue
      expect(issue_7.available_responses).to be_empty
    end

    it "returns responses if current status matches configured status in rules" do
      issue_7.update(status_id: 5) # Close issue
      response.update(initial_status_ids: ['1', '2', '5'])
      expect(issue_7.available_responses).to include response
    end

    it "returns an array of responses when(initial_status_ids contains status new) (tracker_ids contains bug), " do
      User.current = User.find(1)
      res = Response.find(6)

      expect(issue_7.available_responses.size).to eq 3
      expect(issue_7.available_responses).to_not include(res)

      res.initial_status_ids << "1"
      res.save

      expect(issue_7.available_responses.size).to eq 4
      expect(issue_7.available_responses).to include(res)
    end
  end

  context "add responses" do
    pending "adds a response to a specific issue"
    pending "can add a response without changing the status"
    pending "can add a response without final status"
  end

end
