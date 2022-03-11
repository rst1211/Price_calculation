
class Calculate_price
    def bill_calculation
      input = get_input.split(',').map(&:strip)
      @items_bought = input
      if @items_bought.any?
        quantity = count_items_frequency
        price = calculate_bill(quantity)
        display_bill(price, quantity)
      else 
        puts "Please add items"
      end
    end
  
    private
    def get_input
        puts "Please enter all the items purchased separated by a comma"
        input = gets.chomp
    end
  
    def count_items_frequency
        @items_bought.inject(Hash.new(0)) do |quantity, item|
          quantity[item] += 1
          quantity
        end
    end
  
    def calculate_bill(quantity)
        quantity.map do |item,value|
        items = ItemList.all[item]
        sale_items = SaleItems.all[item]
        value = if sale_items.nil?
        quantity[item] * items
        else
        (((quantity[item]/sale_items['units'])) * sale_items['price']) + ((quantity[item] % sale_items['units']) * items)
        end
        [item, value]
        end.to_h
    end
      
    def display_bill(price, quantity)
        billing_items = quantity.each_with_object(price) do |(key,value), billing_items| 
        billing_items[key] = {'units' => value, 'price' => price[key]}
    end
  
        total_price = billing_items.inject(0) do |total, (item,value)|
        total + value['price']
        end
  
        actual_price = quantity.inject(0) do |total, (item,units)| 
        total + (units * ItemList.all[item])
        end
  
        puts "Item     Quantity      Price"
        puts "--------------------------------------"
        billing_items.each do |item, value|
          puts "#{item.ljust(10)} #{value['units']}           $#{value['price'].round(3)}"
        end
        puts "Total price : $#{total_price.round(3)}"
        puts "You saved $#{(actual_price - total_price).round(3)} today."
      end
  end

  class ItemList
    @@items = {}
    def initialize(name, price)
      @@items[name] = price
    end
    
    def self.all
      @@items
    end
end
  
class SaleItems
    @@sale_items = {}
    def initialize(name, units, price)
      @@sale_items[name] = { 'units' => units, 'price' => price }
    end
  
    def self.all
      @@sale_items
    end
end
  
  
  begin
    ItemList.new('milk', 3.97)
    ItemList.new('bread', 2.17)
    ItemList.new('banana', 0.99)
    ItemList.new('apple', 0.89)
  
    SaleItems.new('milk',2,5.00)
    SaleItems.new('bread',3,6.00)
    puts "Items Available:"
    puts "Milk"
    puts "Bread"
    puts "Banana"
    puts "Apple"
    calculator = Calculate_price.new
    puts calculator.bill_calculation
  end
