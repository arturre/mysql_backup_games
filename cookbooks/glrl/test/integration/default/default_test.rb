# # encoding: utf-8

# Inspec test for recipe glrl::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('mysql'), :skip do
    it { should exist }
  end
end

# This is an example test, replace it with your own test.
describe port(3306), :skip do
  it { should be_listening }
end
