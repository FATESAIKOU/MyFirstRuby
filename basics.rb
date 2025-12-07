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
