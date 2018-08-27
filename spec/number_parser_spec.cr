require "./spec_helper"

describe NumberParser do
  it "handles en argument" do
    NumberParser.parse("twelve", lang: "en").should eq "12"
  end

  it "handles straigh parsing" do
    strings = {
      1 => "one",
      5 => "five",
      10 => "ten",
      11 => "eleven",
      12 => "twelve",
      13 => "thirteen",
      14 => "fourteen",
      15 => "fifteen",
      16 => "sixteen",
      17 => "seventeen",
      18 => "eighteen",
      19 => "nineteen",
      20 => "twenty",
      27 => "twenty seven",
      31 => "thirty-one",
      37 => "thirty-seven",
      41 => "forty one",
      42 => "fourty two",
      59 => "fifty nine",
      100 => ["one hundred", "a hundred", "hundred a"],
      150 => ["one hundred and fifty", "one fifty"],
      200 => "two-hundred",
      500 => "5 hundred",
      999 => "nine hundred and ninety nine",
      1_000 => "one thousand",
      1_200 => ["twelve hundred", "one thousand two hundred"],
      17_000 => "seventeen thousand",
      21_473 => "twentyone-thousand-four-hundred-and-seventy-three",
      74_002 => "seventy four thousand and two",
      99_999 => "ninety nine thousand nine hundred ninety nine",
      100_000 => "100 thousand",
      250_000 => "two hundred fifty thousand",
      1_000_000 => "one million",
      1_250_007 => "one million two hundred fifty thousand and seven",
      1_000_000_000 => "one billion",
      1_000_000_001 => "one billion and one"
    }

    strings.each do |key, value|
      val = value.is_a?(Array) ? value : [value]
      val.each do |value|
        NumberParser.parse(value).to_i.should eq key
      end
    end

    NumberParser.parse("half").should eq "1/2"
    NumberParser.parse("quarter").should eq "1/4"
  end

  it "handles combined" do
    NumberParser.parse("twentyone").should eq "21"
    NumberParser.parse("thirtyseven").should eq "37"
  end

  it "handles fractions in words" do
    NumberParser.parse("one half").should eq "1/2"

    NumberParser.parse("1 quarter").should eq "1/4"
    NumberParser.parse("one quarter").should eq "1/4"
    NumberParser.parse("a quarter").should eq "1/4"
    NumberParser.parse("one eighth").should eq "1/8"

    NumberParser.parse("three quarters").should eq "3/4"
    NumberParser.parse("two fourths").should eq "2/4"
    NumberParser.parse("three eighths").should eq "3/8"
    NumberParser.parse("seven tenths").should eq "7/10"
  end

  it "handles fractional addition" do
    NumberParser.parse("one and a quarter").should eq "1.25"
    NumberParser.parse("two and three eighths").should eq "2.375"
    NumberParser.parse("two and a half").should eq "2.5"
    NumberParser.parse("three and a half hours").should eq "3.5 hours"
  end

  it "handles word with a number" do
    NumberParser.parse("pennyweight").should eq "pennyweight"
  end

  it "handles edges" do
    NumberParser.parse("27 Oct 2006 7:30am").should eq "27 Oct 2006 7:30am"
  end

  it "handles multiple slashes" do
    NumberParser.parse("11/02/2007").should eq "11/02/2007"
  end

  it "handles campatability" do
    NumberParser.parse("1/2").should eq "1/2"
    NumberParser.parse("05/06").should eq "05/06"
    NumberParser.parse("three and a half hours").should eq "3.5 hours"
    NumberParser.parse("half an hour").should eq "1/2 an hour"
  end


  it "handles ordinal strings" do

    {
      "first" => "1st",
      "second" => "2nd",
      "third" => "3rd",
      "fourth" => "4th",
      "fifth" => "5th",
      "seventh" => "7th",
      "eighth" => "8th",
      "tenth" => "10th",
      "eleventh" => "11th",
      "twelfth" => "12th",
      "thirteenth" => "13th",
      "sixteenth" => "16th",
      "twentieth" => "20th",
      "twenty-third" => "23rd",
      "thirtieth" => "30th",
      "thirty-first" => "31st",
      "fourtieth" => "40th",
      "fourty ninth" => "49th",
      "fiftieth" => "50th",
      "sixtieth" => "60th",
      "seventieth" => "70th",
      "eightieth" => "80th",
      "ninetieth" => "90th",
      "hundredth" => "100th",
      "thousandth" => "1000th",
      "millionth" => "1000000th",
      "billionth" => "1000000000th",
      "trillionth" => "1000000000000th",
      "first day month two" => "1st day month 2"
    }.each do |key, val|
      NumberParser.parse(key).should eq val
    end
  end

  it "handles ambigous cases" do
    NumberParser.parse("the fourth").should eq "the 4th"
    NumberParser.parse("a third of").should eq "1/3 of"
    NumberParser.parse("fourth").should eq "4th"
    NumberParser.parse("second").should eq "2nd"
    NumberParser.parse("I quarter").should eq "I quarter"
    NumberParser.parse("You quarter").should eq "You quarter"
    NumberParser.parse("I want to quarter").should eq "I want to quarter"
    NumberParser.parse("the first quarter").should eq "the 1st 1/4"
    NumberParser.parse("quarter pound of beef").should eq "1/4 pound of beef"
    NumberParser.parse("the second second").should eq "the 2nd second"
    NumberParser.parse("the fourth second").should eq "the 4th second"
    NumberParser.parse("one second").should eq "1 second"

    # TODO: Find way to distinguish this verb
    # assert_equal "I peel and quarter bananas", NumberParser.parse("I peel and quarter bananas")
  end

  it "handles ignore" do
    NumberParser.parse("the second day of march", ignore: ["second"]).should eq "the second day of march"
    NumberParser.parse("quarter", ignore: ["quarter"]).should eq "quarter"
    NumberParser.parse("the five guys", ignore: ["five"]).should eq "the five guys"
    NumberParser.parse("the fifty two", ignore: ["fifty"]).should eq "the fifty 2"

  end

  it "handles bias ordinal" do
    "4th".should eq NumberParser.parse("fourth", bias: :ordinal)
    "12th".should eq NumberParser.parse("twelfth", bias: :ordinal)
    "2nd".should eq NumberParser.parse("second", bias: :ordinal)
    "the 4th".should eq NumberParser.parse("the fourth", bias: :ordinal)
    "2.75".should eq NumberParser.parse("two and three fourths", bias: :ordinal)
    "3/5".should eq NumberParser.parse("three fifths", bias: :ordinal)
    "a 4th of".should eq NumberParser.parse("a fourth of", bias: :ordinal)
    "I quarter your home".should eq NumberParser.parse("I quarter your home", bias: :ordinal)
    "the 1st 2nd 3rd".should eq  NumberParser.parse("the first second third", bias: :ordinal)
  end

  it "handles bias fractional" do
    "1/4".should eq NumberParser.parse("fourth", bias: :fractional)
    "1/12".should eq NumberParser.parse("twelfth", bias: :fractional)
    "2nd".should eq NumberParser.parse("second", bias: :fractional)
    "the 1/4".should eq NumberParser.parse("the fourth", bias: :fractional)
    "2.75".should eq NumberParser.parse("two and three fourths", bias: :fractional)
    "3/5".should eq NumberParser.parse("three fifths", bias: :fractional)
    "1/4 of".should eq NumberParser.parse("a fourth of", bias: :fractional)
    "I 1/4 your home".should eq NumberParser.parse("I quarter your home", bias: :fractional)
    "the 1st second 1/3".should eq  NumberParser.parse("the first second third", bias: :fractional)
  end
end
