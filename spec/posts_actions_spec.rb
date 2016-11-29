require 'spec_helper'

describe 'posts index', type: :feature, js: true do

  before do
    @john = Author.create!(name: 'John', last_name: 'Doe')
    @jane = Author.create!(name: 'Jane', last_name: 'Roe')

    Post.create!(title: 'John Post', body: '...', author: @john)
    Post.create!(title: 'Jane Post', body: '...', author: @jane)
  end

  before do
    add_post_resource
  end

  before do
    visit '/admin/posts'
  end

  context 'update posts body and author fields' do
    let(:new_body_text) { 'Text here...' }
    let(:new_author) { @jane }

    before do
      page.find('#collection_actions_sidebar_section button', text: 'Update').click
      page.within ('body>.active_admin_dialog_mass_update_by_filter') do
        page.find('input[name="body"]').set(new_body_text)

        page.find('select[name="author_id"]').select(new_author.name)
        page.find('button', text: 'OK').click
      end
    end

    it 'update successfully' do
      expect(page).to have_css('.flashes .flash.flash_notice')
      expect(Post.all.map(&:body).uniq).to match_array([new_body_text])
      expect(Post.all.map(&:author).uniq).to match_array([new_author])
    end
  end

end
