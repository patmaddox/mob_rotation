require_relative 'spec_helper'

describe MobRotation do
  extend FooFighter

  let(:mob_rotator) { MobRotation.new(MobRotation::Database.new(file_name)) }

  describe "#show_mobsters" do

    let(:file_name) { "test.txt" }
    let(:output) { Output.new }

    before do
      File.open(file_name, "w") do |file|
        file << "Bob\n" << "Phoebe\n" << "Joe\n"
      end

      $stdout = output

      mob_rotator.show_mobsters()
    end

    it "print out all the mobsters in the text file" do
      expect(output.mobsters.join).to include("Mobster Joe")
    end

    it "prints out driver" do
      expect(output.mobsters.join).to include("Driver Bob")
    end

    it "prints out navigator" do
      expect(output.mobsters.join).to include("Navigator Phoebe")
    end
  end

  describe "#add_mobster" do
    let(:file_name) { "test.txt" }

    it "adds a mobster to the file" do
      mob_rotator.add_mobster 'Jackie'
      mob_rotator.add_mobster 'Phil'

      expect(File.read(file_name)).to eq("Bob\nPhoebe\nJoe\nJackie\nPhil\n")
    end

    it "adds a mobster with no db file" do
      FileUtils.rm(file_name)

      mob_rotator.add_mobster 'Jackie'

      expect(File.read(file_name)).to include('Jackie')
     end

    it "accepts more than one mobster" do
      
      mob_rotator.add_mobster "Jackie", "Phil"
      expect(File.read(file_name)).to include("\nPhil")
    end
  end
  
  describe "#remove_mobster" do
    let(:file_name) { "test_remove.txt" }
    
    before do
      FileUtils.rm_f(file_name)

      File.open(file_name, "w") do |file|
        file << "Bob\n" << "Phoebe\n" << "Joe"
      end
    end

    it "removes a mobster from the file" do
      mob_rotator.remove_mobster "Bob"
      expect(File.read(file_name)).not_to include('Bob')

    end
  end

  describe "#rotate" do
    let(:file_name) { "test_remove.txt" }
    
    before do
      FileUtils.rm_f(file_name)
      File.open(file_name, "w") do |file|
        file << "Bob\n" << "Phoebe\n" << "Joe\n"
      end
    end
    
    it "rotates mobsters" do
      
      mob_rotator.rotate
      # new file to equal 'Phoebe Joe Bob'
      expect(File.read(file_name)).to eq("Phoebe\nJoe\nBob\n")
    end
  end

  describe ".extract_email_from(entry)" do
    after(:each) do
      FileUtils.rm_f("irrelevant_file")
    end
    
    it "returns the email address" do
      email = MobRotation.new(MobRotation::Database.new("irrelevant_file")).extract_email_from('a <b@example.com>')
      expect(email).to eq('b@example.com')
    end

    it "it handles arbitary email addresses" do
      email = MobRotation.new(MobRotation::Database.new('irrelevant_file')).extract_email_from('bob <bob@example.com>')
      expect(email).to eq('bob@example.com')
    end

  end
end

