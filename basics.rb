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

puts '<<<<<<User>>>>>>'
puts user[name_symbol]
puts user[age_symbol]
puts '<<<<<<>>>>>>'

puts '########## Step test variables - End ##########'

# Branches

puts '########## Step test branches - Start ##########'
if age >= 18
    puts '[if-else] #{name} is an adult.'
else
    puts '[if-else] #{name} is a minor.'
end

unless age < 18
    puts '[unless] #{name} is an adult.'
else
    puts '[unless] #{name} is a minor.'
end

puts '[ternary] #{name} is ' + (age >= 18 ? 'an adult.' : 'a minor.')
puts '[Single line if] #{name} is an adult.' if age >= 18
puts '[Single line unless] #{name} is a minor.' unless age < 18

case age
when 0..12
    puts '[case] #{name} is a child.'
when 13..19
    puts '[case] #{name} is a teenager.'
else
    puts '[case] #{name} is an adult.'
end

puts '########## Step test branches - End ##########'

## Loops

puts '########## Step test loops - Start ##########'

i = 0
while i < 3 do
    puts "[while] Iteration #{i}"
    i += 1
end

i = 0
until i >= 3 do
    puts "[until] Iteration #{i}"
    i += 1
end

for j in 0..2 do
    puts "[for] Iteration #{j}"
end

(0..2).each do |k|
    puts "[each] Iteration #{k}"
end

(0..2).each { |l| puts "[each with braces] Iteration #{l}" }

5.times do |m|
    puts "[times] Iteration #{m}"
end

(0..2).map do |n|
    puts "[map] Iteration #{n}"
end

puts '########## Step test loops - End ##########'

# Methods

puts '########## Step test methods - Start ##########'

def add(x, y)
    return x + y
end

puts "[add] 5 + 3 = #{add(5, 3)}"

def add_default(x, y = 10)
    return x + y
end

puts "[add_default] 5 + default(10) = #{add_default(5)}"
puts "[add_default] 5 + 7 = #{add_default(5, 7)}"

def sum(*numbers)
    return numbers.reduce(0) { |total, num| total + num }
end

puts "[sum] Sum of 1, 2, 3, 4, 5 = #{sum(1, 2, 3, 4, 5)}"

def register_user(name:, age:)
    return { name: name, age: age }
end
user_info = register_user(name: 'Alice', age: 30)
puts "[register_user] #{user_info}"

def kwargs_args_mix(x, y = 5, *args, option1:, option2: 'default', **kwargs)
    puts "[kwargs_args_mix] x: #{x}, y: #{y}, args: #{args}, option1: #{option1}, option2: #{option2}, kwargs: #{kwargs}"
end

kwargs_args_mix(1, 2, 3, 4, option1: 'value1', extra1: 'extra_value1', extra2: 'extra_value2')

def self_instance_method(caller_prompt)
    puts "[self_instance_method] Called on instance #{self} from #{caller_prompt}"
end

self_instance_method('call directly')
self.self_instance_method('from main context')
begin
    Object.new.self_instance_method('from Object instance')
rescue NoMethodError => e
    puts "[Error] #{e.message}"
end

def self.self_class_method(caller_prompt)
    puts "[self_class_method] Called on class #{self} from #{caller_prompt}"
end

self_class_method('call directly')
self.self_class_method('from main context')
begin
    Object.self_class_method('from Object class')
rescue NoMethodError => e
    puts "[Error] #{e.message}"
end

## Lambda
my_lambda = ->(a, b) { a * b }
puts "[lambda] 4 * 5 = #{my_lambda.call(4, 5)}"

## function call to define method
define_method(:dynamic_method) do |msg|
    puts "[dynamic_method] #{msg}"
end
dynamic_method('Hello from dynamic method!')

puts '########## Step test methods - End ##########'

# Classes
puts '########## Step test classes - Start ##########'
class Person
    attr_accessor :name, :age

    def initialize(name, age)
        @name = name
        @age = age
    end

    def introduce
        puts "[introduce] Hi, I'm #{@name} and I'm #{@age} years old."
    end
end

person = Person.new('Bob', 25)
person.introduce

## Inheritance
class Student < Person
    attr_accessor :student_id

    def initialize(name, age, student_id)
        super(name, age)
        @student_id = student_id
    end

    def introduce
        super()
        puts "[introduce] My student ID is #{@student_id}."
    end
end

student = Student.new('Charlie', 22, 'S12345')
student.introduce

## Implementing Modules
module Greeter
    def greet
        puts "[greet] Hello, #{@name}!"
    end
end
class Teacher < Person
    include Greeter

    attr_accessor :subject

    def initialize(name, age, subject)
        super(name, age)
        @subject = subject
    end

    def introduce
        super()
        puts "[introduce] I teach #{@subject}."
    end
end

teacher = Teacher.new('Diana', 30, 'Math')
teacher.introduce
teacher.greet

## Interface check function with include and respond_to?
def implements_interface?(obj, *modules)
    modules.all? do |mod|
        obj.class.included_modules.include?(mod) &&
        mod.instance_methods.all? { |method| obj.respond_to?(method) }
    end
end

## Overriding Module Methods
module Fareweller
    def farewell
        puts "[farewell] Goodbye from module!"
    end
end
class Staff < Person
    include Fareweller

    def farewell
        puts "[farewell] Goodbye from Staff class!"
    end
end

staff = Staff.new('Eve', 28)
staff.farewell

puts "[implements_interface?] Does teacher implement Greeter? #{implements_interface?(teacher, Greeter)}"
puts "[implements_interface?] Does staff implement Fareweller? #{implements_interface?(staff, Fareweller)}"

## Module extend
module Announcer
    def announce
        puts "[announce] Announcement from module!"
    end
end
class Principal < Person
    extend Announcer
end

Principal.announce
puts "[implements_interface?] Does Principal implement Announcer? #{Principal.singleton_class.included_modules.include?(Announcer)}"

puts '########## Step test classes - End ##########'