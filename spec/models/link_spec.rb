require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :name }

  describe 'URL validation' do
    it { should allow_value("https://google.com").for(:url)}

    it { should_not allow_value("plain text").for(:url)}
  end

  describe '.gist?' do
    let(:question) { create(:question) }

    it 'should return True if url is gist' do
      link = create(:link, name: 'gist url', url: 'https://gist.github.com/WhatTheAncient/1321b95523b67e906ac7a9f6001fecd8', linkable: question)
      expect(link).to be_gist
    end

    it 'should return False if url is not gist' do
      link = create(:link, linkable: question)
      expect(link).to_not be_gist
    end
  end
end
