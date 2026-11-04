require "test_helper"

class SettingsStoreTest < ActiveSupport::TestCase
  setup do
    @path = Rails.root.join("tmp", "settings-test-#{Process.pid}.pstore").to_s
    File.delete(@path) if File.exist?(@path)
    @original_store = Settings.instance.store
    Settings.instance.store = PStore.new(@path, true)
  end

  teardown do
    Settings.instance.store = @original_store
    File.delete(@path) if File.exist?(@path)
  end

  test "returns a value saved by another process" do
    Settings[:title] = "First"
    assert_equal "First", Settings[:title]

    # Same length, saved straight away: the file's size and mtime may not change.
    other_process_store = PStore.new(@path)
    other_process_store.transaction { other_process_store[:title] = "Later" }

    assert_equal "Later", Settings[:title]
  end

  test "returns a value saved by another process after the cache settles" do
    Settings[:title] = "First"
    File.utime(Time.now - 10, Time.now - 10, @path)
    assert_equal "First", Settings[:title]

    other_process_store = PStore.new(@path)
    other_process_store.transaction { other_process_store[:title] = "Later" }

    assert_equal "Later", Settings[:title]
  end

  test "saving a value stores it and returns it" do
    Settings[:title] = "Saved"

    assert_equal "Saved", Settings[:title]
    assert_equal "Saved", PStore.new(@path).transaction(true) { |store| store[:title] }
  end

  test "returns the default when nothing is stored" do
    assert_equal "GatherPack", Settings[:title]
  end

  test "boolean settings compare the stored string" do
    Settings[:local_auth] = "true"
    assert_equal true, Settings[:local_auth]

    Settings[:local_auth] = "false"
    assert_equal false, Settings[:local_auth]
  end

  test "threads wait for each other's transactions on the settings store" do
    threads = 5.times.map do
      Thread.new { 100.times { @original_store.transaction(true) { } } }
    end

    assert_nothing_raised { threads.each(&:join) }
  end

  test "threads can read and save at the same time" do
    threads = 5.times.map do |i|
      Thread.new { 100.times { |n| i.zero? ? Settings[:title] = "Title #{n}" : Settings[:title] } }
    end

    assert_nothing_raised { threads.each(&:join) }
  end
end
