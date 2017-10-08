require 'takeaway'

describe Takeaway do

  let(:dish1) { 'wonton' }
  let(:dish1_price) { 3.46 }
  let(:dish2) { 'seaweed' }
  let(:dish2_price) { 3.57 }
  let(:basket) { double('basket', add: nil, total: 0, summary: nil) }
  let(:basket_class) { class_double('basket_class', new: basket) }
  let(:message_service) { double('message_service', send_sms: nil) }
  let(:menu) { double('menu', print: nil, items: { dish1 => dish1_price, dish2 => dish2_price }) }

  before do
    allow($stdout).to receive(:write)
  end

  subject(:takeaway) { described_class.new(menu, basket_class, message_service) }

  describe '#print_menu' do

    it 'prints the menu' do
      expect(menu).to receive :print
      takeaway.print_menu
    end

  end

  describe '#order' do
    
    it 'adds an dish to the basket' do
      expect(basket).to receive(:add).with(dish1, dish1_price)
      takeaway.order dish1
    end
    it 'allows to specify a quantity of dishes to add' do
      expect(basket).to receive(:add)
        .exactly(3).times.with(dish1, dish1_price)
      takeaway.order(dish1, 3)
    end
    it "raises an error if the dish isn't on the menu" do
      error = 'dish is not on the menu'
      expect { takeaway.order 'fish sauce' }.to raise_error error
    end
    it 'confirms that the items have been added to the basket' do
      str = "1 #{dish1} added to basket\n"
      expect { takeaway.order dish1 }.to output(str).to_stdout
    end

  end
    
  describe '#order_summary' do

    it 'shows the order summary' do
      expect(basket).to receive :summary
      takeaway.order_summary
    end

  end

  describe '#order_total' do

    it 'shows the total cost of all items in the basket' do
      expect(basket).to receive :total
      takeaway.order_total
    end

  end

  describe '#checkout_order' do

    it "raises an error if the wrong payment is received" do
      error = 'please pay the correct amount'
      takeaway.order dish1
      expect { takeaway.checkout_order(dish1_price + 1) }.to raise_error error
    end
    it "empties the basket" do
      expect(takeaway.basket_class).to receive :new
      takeaway.order dish1
      allow(basket).to receive(:total) { dish1_price }
      takeaway.checkout_order(dish1_price)
    end
    it 'sends an sms confirmation to the user' do
      takeaway.order dish1
      allow(basket).to receive(:total) { dish1_price }
      expect(takeaway).to receive(:send_confirmation)
      takeaway.checkout_order(dish1_price)
    end
    
  end

end
