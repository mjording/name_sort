require 'spec_helper'

describe NameSort do
  it 'has a version number' do
    expect(NameSort::VERSION).not_to be nil
  end

  describe 'header' do
    let(:sorter){ NameSort::Sorter.new }
    it "raises a InvalidDeliminatorError unless given valid delimiter" do
      expect { sorter.header('p') }.to raise_error(
        NameSort::InvalidDeliminatorError
      )
    end
    it "always begins with last and first name" do
      [' ', '|',','].each do |delim|
        expect(sorter.header(delim).first(2)).to eq %w(last_name first_name)
      end
    end
  end

  describe "input" do
    let(:sorter){ NameSort::Sorter.new }

    describe "space delimited file" do
      let(:file){ "./spec/fixtures/space.txt" }
      it "adds 3 records to names" do
        initial_length = sorter.names.length
        sorter.input(" ", file)
        expect(sorter.names.length).to eq initial_length + 3
      end
    end

    describe "pipe delimited file" do
      let(:file){ "./spec/fixtures/pipe.txt" }
      it "adds 3 records to names" do
        initial_length = sorter.names.length
        sorter.input("|", file)
        expect(sorter.names.length).to eq initial_length + 3
      end
    end

    describe "comma delimited file" do
      let(:file){ "./spec/fixtures/comma.txt" }
      it "adds 3 records to names" do
        initial_length = sorter.names.length
        sorter.input(",", file)
        expect(sorter.names.length).to eq initial_length + 3
      end
    end
  end

  describe "format_for" do
    let(:sorter){ NameSort::Sorter.new }
    it "calls format_gender" do
      allow(sorter).to receive(:format_gender).with(:any_args).and_return("Male")
      expect(sorter).to receive(:format_gender)
      sorter.format_for('gender', 'M')
    end

    it "calls format_date" do
      allow(sorter).to receive(:format_date).with(:any_args).and_return(DateTime.now)
      expect(sorter).to receive(:format_date)
      sorter.format_for('date_of_birth', '10-24-1974')
    end

    it "returns a striped value" do
      expect(sorter.format_for('field','  stripped value  ')).to eq 'stripped value'
    end
  end

  describe "format_gender" do
    let(:sorter){ NameSort::Sorter.new }
    it "returns Male when given 'male' or 'M'" do
      expect(sorter.format_gender('M')).to eq "Male"
      expect(sorter.format_gender('male')).to eq "Male"
      expect(sorter.format_gender('MALE')).to eq "Male"
    end
    it "returns Female when given 'female' or 'F'" do
      expect(sorter.format_gender('F')).to eq "Female"
      expect(sorter.format_gender('female')).to eq "Female"
      expect(sorter.format_gender('FEMALE')).to eq "Female"
    end
  end

  describe "format_date" do
    let(:sorter){ NameSort::Sorter.new }
    it "returns a date object" do
      expect(sorter.format_date('6/10/2004')).to be_instance_of Date
    end
    it "parses month day and year appropriately" do
      expect(sorter.format_date('6/10/2004').year).to eq 2004
      expect(sorter.format_date('6/10/2004').month).to eq 6
      expect(sorter.format_date('6/10/2004').day).to eq 10
      expect(sorter.format_date('6-10-2004').year).to eq 2004
      expect(sorter.format_date('6-10-2004').month).to eq 6
      expect(sorter.format_date('6-10-2004').day).to eq 10
    end
  end

  describe "sort_for" do
    let(:sorter){ NameSort::Sorter.new }

    it "should sort by field" do
      {
        "|" => "./spec/fixtures/pipe.txt",
        " " => "./spec/fixtures/space.txt",
        "," => "./spec/fixtures/comma.txt"
      }.each_pair do |k,v|
        sorter.input(k,v)
      end
      expect(sorter.sort_for('gender').first(4).map{|record|record[2]}.uniq).to eq ["Female"]
    end
  end

  describe "format_fields" do
    let(:sorter){ NameSort::Sorter.new }
    let(:record){ [ "LastName","FirstName", "Male", Date.new(2003,4,16), "blue" ]}
    let(:expected_return){ [ "LastName","FirstName", "Male", "4/16/2003", "blue" ]}
    it "returns formated value" do
      expect(sorter.format_fields(record)).to eq expected_return
    end
  end
end
