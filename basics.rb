#!/usr/bin/env ruby

# Variables

puts '########## Step test variables - Start ##########'

name = 'P2P'
age = 20
user = {
    name: name,
    age: age,
}

puts user

name_symbol = :name
age_symbol = :age

puts "<<<<<<User>>>>>>"
puts user[name_symbol]
puts user[age_symbol]
puts "<<<<<<>>>>>>"

puts '########## Step test variables - End ##########'

# Branches

puts '########## Step test branches - Start ##########'
if age >= 18
    puts "[if-else] #{name} is an adult."
else
    puts "[if-else] #{name} is a minor."
end

unless age < 18
    puts "[unless] #{name} is an adult."
else
    puts "[unless] #{name} is a minor."
end

puts "[ternary] #{name} is " + (age >= 18 ? "an adult." : "a minor.")
puts "[Single line if] #{name} is an adult." if age >= 18
puts "[Single line unless] #{name} is a minor." unless age < 18

case age
when 0..12
    puts "[case] #{name} is a child."
when 13..19
    puts "[case] #{name} is a teenager."
else
    puts "[case] #{name} is an adult."
end

puts '########## Step test branches - End ##########'