
require 'httparty'

response = HTTParty.get('http://shopicruit.myshopify.com/products.json')
json = JSON.parse(response.body)


#flatten json to make it easier to work with
KnapsackItem = Struct.new(:name, :weight, :value)
product_list = Array.new
json['products'].each do |product|
	if(product['product_type'] == 'Keyboard' || product['product_type'] == 'Computer')

    product['variants'].each do |variant|
      product_list.push(KnapsackItem.new(product['title'], variant['grams'], variant['price'].to_f  ))
    end
	end
end

#from http://rosettacode.org/wiki/Knapsack_problem/0-1#Dynamic_Programming
def dynamic_programming_knapsack(items, max_weight)
  num_items = items.size
  cost_matrix = Array.new(num_items){Array.new(max_weight+1, 0)}
 
  num_items.times do |i|
    (max_weight + 1).times do |j|
      if(items[i].weight > j)
        cost_matrix[i][j] = cost_matrix[i-1][j]
      else
        cost_matrix[i][j] = [cost_matrix[i-1][j], items[i].value + cost_matrix[i-1][j-items[i].weight]].max
      end
    end
  end
  used_items = get_used_items(items, cost_matrix)
  [get_list_of_used_items_names(items, used_items),                     # used items names
   items.zip(used_items).map{|item,used| item.weight*used}.inject(:+),  # total weight
   cost_matrix.last.last]                                               # total value
end
 
def get_used_items(items, cost_matrix)
  i = cost_matrix.size - 1
  currentCost = cost_matrix[0].size - 1
  marked = cost_matrix.map{0}
 
  while(i >= 0 && currentCost >= 0)
    if(i == 0 && cost_matrix[i][currentCost] > 0 ) || (cost_matrix[i][currentCost] != cost_matrix[i-1][currentCost])
      marked[i] = 1
      currentCost -= items[i].weight
    end
    i -= 1
  end
  marked
end
 
def get_list_of_used_items_names(items, used_items)
  items.zip(used_items).map{|item,used| item.name if used>0}.compact.join(', ')
end
 

names, weight, value = dynamic_programming_knapsack(product_list, 100000)
  puts
  puts 'Dynamic Programming:'
  puts
  puts "Found solution: #{names}"
  puts "total weight: #{weight}"
  puts "total value: #{value}"


