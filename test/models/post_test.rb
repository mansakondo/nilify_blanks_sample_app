require "test_helper"

class PostTest < ActiveSupport::TestCase
  setup do
    @post = Post.new
  end

  test "should nilify empty values" do
    @post.tags      = ["", nil]
    @post.metadata  = { "foo" => "", "bar" => nil}

    @post.save
    @post.reload

    refute @post.tags
    refute @post.metadata

    @post.tags      = '["", nil]'
    @post.metadata  = '{ "foo" => "", "bar" => nil}'

    @post.save
    @post.reload

    refute @post.tags
    refute @post.metadata
  end

  test "should remove blank values" do
    @post.tags     = ["ruby", "", "rails", nil]
    @post.metadata = { "ruby" => "ruby", "foo" => "", "rails" => "rails", "bar" => nil }

    @post.save
    @post.reload

    assert_equal 2, @post.tags.count
    assert_equal 2, @post.metadata.count

    @post.tags     = '["ruby", "", "rails", nil]'
    @post.metadata = '{ "ruby" => "ruby", "foo" => "", "rails" => "rails", "bar" => nil }'

    @post.save
    @post.reload

    assert_equal 2, @post.tags.count
    assert_equal 2, @post.metadata.count
  end

  test "should always nilify values before sending them to the database" do
    @post.tags     = '["ruby", "", "rails", nil]'
    @post.metadata = '{ "ruby" => "ruby", "foo" => "", "rails" => "rails", "bar" => nil }'

    @post.save
    @post.reload

    assert_equal 2, @post.tags.count
    assert_equal 2, @post.metadata.count

    @post.tags << nil
    @post.metadata["test"] = nil

    @post.save
    @post.reload

    assert_equal 2, @post.tags.count
    assert_equal 2, @post.metadata.count
  end
end
