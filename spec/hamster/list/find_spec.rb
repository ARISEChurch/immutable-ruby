require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  [:find, :detect].each do |method|

    describe "##{method}" do

      describe "on a really big list" do

        before do
          @list = Hamster.interval(0, 100000)
        end

        it "doesn't run out of stack space" do
          @list.send(method) { false }
        end

      end

      [
        [[], "A", nil],
        [[], nil, nil],
        [["A"], "A", "A"],
        [["A"], "B", nil],
        [["A"], nil, nil],
        [["A", "B", nil], "A", "A"],
        [["A", "B", nil], "B", "B"],
        [["A", "B", nil], nil, nil],
        [["A", "B", nil], "C", nil],
      ].each do |values, item, expected|

        describe "on #{values.inspect}" do

          before do
            @list = Hamster.list(*values)
          end

          describe "with a block" do

            it "returns #{expected}" do
              @list.send(method) { |x| x == item  }.should == expected
            end

          end

          describe "without a block" do

            it "returns nil" do
              @list.send(method).should be_nil
            end

          end

        end

      end

    end

  end

end